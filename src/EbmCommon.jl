"""
Grounded but not too grounded facility for
numerical experiment with EBMs.
"""
module EbmCommon

using OrdinaryDiffEqTsit5
using DocStringExtensions
using Chain: @chain
using RequiredInterfaces
using MakieCore
using Makie
using Makie.LaTeXStrings
using UnPack
import Oxygen

"""
An interface for all EBM parameters.
"""
abstract type AbstractEbmParams end

"""
Alias for `Type{<:AbstractEbmParams}` to be used in type annotations.
"""
const TEP = Type{<:AbstractEbmParams}

@kwdef struct VariableSpecs
    name::Symbol
    default::Float64
    index::Int
    description::String = "u[i]"
    latexname::String = String(name)
end

@kwdef struct ParameterSpecs
    name::Symbol
    description::String
    default::Float64
    alias::Symbol = name
    latexname::String = String(name)
end

@kwdef struct ModelSpecs
    variables::Vector{VariableSpecs}
    parameters::Vector{ParameterSpecs}
    time_axis_name::String = "Time"
    state_axis_name::String = "Density"
end

"""
Receives a parameter set, returns a DifferentialEquations's ode.
"""
function EvolutionRule end

"""
This function should return a function that:

  - Receives:

      + A base parameter set
      + a Varargs of Pair{Symbol,Iterable}
      + maybe some extra keyword args?

  - Returns the updated parameter set.
"""
function ParamsUpdater end

"""
Returns the evolution rule for the model.

This function should return a function that is used
by `ODEProblem`.

See also: `ODEProblem`.
"""
EvolutionRule(T::TEP) = error("EvolutionRule not implemented for $(T)")

"""
Returns the function that updates the parameters of the model.

The function should have the same signature as: `update_params`.

See also: `update_params`.
"""
ParamsUpdater(T::TEP) = error("ParamsUpdater not implemented for $(T)")

"""
Returns the function that calculates the Jacobian of a model.

The jacobian function should have the signature:

```julia
Jacobian(p::AbstractEbmParams, u::AbstractVector) -> AbstractMatrix
```
"""
Jacobian(T::TEP) = error("Jacobian not implemented for $(T)")

"""
Make it easy to get the Jacobian for a parameter Type.
"""
Jacobian(params::AbstractEbmParams) = Jacobian(typeof(params))

"""
Returns number of variables in the model
"""
number_of_variables(T::TEP) = begin
    error("number_of_variables not implemented for $(T)")
end

"""
Returns the number of equilibria in the model.
"""
number_of_equilibria(T::TEP) = begin
    error("number_of_equilibria not implemented for $(T)")
end

"""
Returns parameter/variable name in LaTeX format.
"""
get_latex_name(T::TEP, ::Symbol) = begin
    error("get_latex_name not implemented for $T")
end

"""
Returns variable name in LaTeX format.
"""
get_latex_name(T::TEP, ::Integer) = begin
    error("get_latex_name not implemented for $T")
end

"""
Get latex name for the parameter or variable.

Delegates from `get_latex_name(params::AbstractEbmParams, ...)`
to the type `get_latex_name(typeof(params), ...)`.
"""
get_latex_name(params::AbstractEbmParams, name) = begin
    get_latex_name(typeof(params), name)
end

"""
Get plotting x-axis label for the model.
"""
get_xlabel(::Type{<:AbstractEbmParams}) = "Time"

"""
Get plotting y-axis label for the model.
"""
get_ylabel(::Type{<:AbstractEbmParams}) = "Density"

"""
$(TYPEDSIGNATURES)

Returns a bit vector of local stabilities of the equilibria in the model.
"""
function get_local_stabilities(params::T)::BitVector where {T <: AbstractEbmParams}
    error("get_local_stabilities not implemented for $(T)")
end

"""
$(TYPEDSIGNATURES)

Returns a vector of equilibria for the model.
"""
function get_equilibria(params::T)::Vector where {T <: AbstractEbmParams}
    error("get_equilibria not implemented for $(T)")
end

const FloatType = Float64
const ParameterChange = Pair{Symbol, T} where {T <: AbstractArray}

"""
Simulate the model, the parameters must have an evolution
rule to be simulated.

Returns `ODESolution` (Unwrapped).

See `DifferentialEquations` package documentation for more detail.

See also: `EvolutionRule`, `ODEProblem`, `DifferentialEquations.solve`.
"""
function _simulate(params::AbstractEbmParams, u0::AbstractVector, tspan; solver_options...)
    rule = EvolutionRule(params)
    prob = ODEProblem(rule, u0, tspan, params)
    solve(prob, Tsit5(); solver_options...)
end

"""
Collect parameter to a dictionary of Symbol => T.

The parameter must subtype `AbstractEbmParams` to use this method.
"""
function Base.collect(p::AbstractEbmParams)
    names = propertynames(p)
    return Dict(name => getproperty(p, name) for name in names)
end

"""
This is the default pretty printing for the parameters.

The parameter must subtype `AbstractEbmParams` to use this method.
"""
function Base.show(io::IO, params::T) where {T <: AbstractEbmParams}
    names = propertynames(params)
    values = Iterators.map(name -> getproperty(params, name), names)
    lines = ("\t$name = $value" for (name, value) in zip(names, values))
    output = "$T\n$(join(lines, '\n'))"
    print(io, output)
end

include("simulate.jl")
include("bifurcation-1d.jl")
include("bifurcation-2d.jl")
include("phase-2d.jl")
include("plotting/compartment.jl")
include("plotting/phase_portrait.jl")
include("plotting/bifurcation_1d.jl")
include("plotting/bifurcation_2d.jl")

# Deprecated
# include("recipes.jl")
#= include("api-server.jl") =#
#= include("example.jl") =#

"""
    check_routh_hurwitz(a0, a1, a2, a3, ...)

Check Routh-hurwitz stability for polynomial of order 1, 2, 3 and 4.

The polynomial coefficients correspond to the order of the polynomial:

  - `a0` - coefficient of x^0
  - `a1` - coefficient of x^1
  - `a2` - coefficient of x^2
  - `a3` - coefficient of x^3
    and so on.
"""
function check_routh_hurwitz(a01234...)
    cond = all(a01234 .> 0)
    n = length(a01234)
    if n > 3
        a0, a1, a2, a3 = a01234
        cond &= a2 * a1 - a0 * a3 > 0
    end
    if n > 4
        a0, a1, a2, a3, a4 = a01234
        cond &= a3 * a2 * a1 - a4 * a1^2 - a3^2 * a0 > 0
    end
    if n > 5
        @error "Unsupported"
    end
    return cond
end

"""
    $(TYPEDSIGNATURES)

Receives a parameter set of type `P` and some pairs of `Symbol => V` that correspond to the changes in the parameters' values. Returns the updated parameter set.

The type `P` must implement `ParamsUpdater(::Type{P})` method for
this function to work.

Optional changes can be passed to the function that `ParamsUpdater` returns using `kwargs...`.

See also: `ParamsUpdater`.
"""
function update_params(params, updates::Vector{ParameterChange}...; kwargs...)
    updater = ParamsUpdater(params)
    return updater(params, updates...; kwargs...)
end

"""
$(TYPEDSIGNATURES)

Returns the Jacobian matrix of the model at the state `u`.

The input `params::P` must implement `Jacobian(::Type{P})` method for
this function to work.

See also: `Jacobian`.
"""
function jacobian(params::T, u::AbstractVector) where {T}
    jac = Jacobian(T)
    return jac(params, u)
end

export Jacobian, EvolutionRule, ParamsUpdater, AbstractEbmParams
export Bifurcation1d, PhasePortrait2d
export simulate, update_params, check_routh_hurwitz, jacobian
export plot_bifurcation_1d, plot_compartments, plot_phase_portrait

"""
$(TYPEDSIGNATURES)

Check if a method is implemented for a given type by
checking if the method for the type is different from the
default one for `AbstractEbmParams`.
"""
function _has_implemented_method(f, sig_impl, sig_base)::Bool
    method_impl = methods(f, sig_impl)
    method_abstract = methods(f, sig_base)
    return method_impl != method_abstract
end

"""
$(TYPEDSIGNATURES)

Check if all required methods are implemented for a given type `T`.
"""
function check_implemented_methods(::Type{T}) where {T}
    methods_to_check = [
        (EvolutionRule, (Type{T},), (Type{AbstractEbmParams},)),
        (ParamsUpdater, (Type{T},), (Type{AbstractEbmParams},)),
        (Jacobian, (Type{T},), (Type{AbstractEbmParams},)),
        (get_xlabel, (Type{T},), (Type{AbstractEbmParams},)),
        (get_ylabel, (Type{T},), (Type{AbstractEbmParams},)),
        (number_of_variables, (Type{T},), (Type{AbstractEbmParams},)),
        (number_of_equilibria, (Type{T},), (Type{AbstractEbmParams},)),
        (get_latex_name, (Type{T}, Symbol), (Type{AbstractEbmParams}, Symbol)),
        (get_latex_name, (Type{T}, Integer), (Type{AbstractEbmParams}, Integer)),
        (get_equilibria, (T,), (AbstractEbmParams,)),
        (get_local_stabilities, (T,), (AbstractEbmParams,)),
    ]

    ok = true
    for (method, sig_impl, sig_abs) in methods_to_check
        if !_has_implemented_method(method, sig_impl, sig_abs)
            @error "Method $(method) is not implemented for $T"
            ok = false
        end
    end

    return ok
end

public check_implemented_methods

end # module EbmCommon
