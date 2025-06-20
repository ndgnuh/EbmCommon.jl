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

abstract type AbstractEbmParams end

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
    - A base parameter set
    - a Varargs of Pair{Symbol,Iterable}
    - maybe some extra keyword args?
- Returns the updated parameter set.
"""
function ParamsUpdater end

"""
Returns a function that receive the model state,
and calculate the model's jacobian at that state.
"""
function Jacobian end

"""
Number of variables in the system.
"""
function number_of_variables end

"""
Number of equilibria in the system.
"""
function number_of_equilibria end

"""
A function that returns Vector of the model's equilibria
"""
function get_equilibria end

"""
A function that returns BitVector of the equilibria's local stability
"""
function get_local_stabilities end

@required AbstractEbmParams begin
    EvolutionRule(::AbstractEbmParams)
    ParamsUpdater(::AbstractEbmParams)
    Jacobian(::AbstractEbmParams)

    number_of_variables(::AbstractEbmParams)
    number_of_equilibria(::AbstractEbmParams)
    get_equilibria(::AbstractEbmParams)
    get_local_stabilities(::AbstractEbmParams)
    get_model_specifications(::AbstractEbmParams)
end

"""
Returns parameter/variable name in LaTeX format.
"""
get_latex_name(::Type{<:AbstractEbmParams}, ::Symbol) = error("get_latex_name not implemented for $(typeof(AbstractEbmParams))")

"""
Returns variable name in LaTeX format.
"""
get_latex_name(::Type{<:AbstractEbmParams}, ::Integer) = error("get_latex_name not implemented for $(typeof(AbstractEbmParams))")

"Get plotting x-axis label for the model."
get_xlabel(::Type{<:AbstractEbmParams}) = "Time"

"Get plotting y-axis label for the model."
get_ylabel(::Type{<:AbstractEbmParams}) = "Density"


"""
Return a map of information, indexed by parameters.
"""
function get_parameter_specifications(p::AbstractEbmParams)
    model_specs = get_model_specifications(p)
    Dict(map(model_specs.parameters) do p
        p.name => p
    end)
end

"""
Return a map of variable information, indexed by index of variables.
"""
function get_variable_specifications(p::AbstractEbmParams)
    model_specs = get_model_specifications(p)
    Dict(map(enumerate(model_specs.variables)) do (i, p)
        p.index => p
    end)
end

const FloatType = Float64
const ParameterChange = Pair{Symbol,T} where {T<:AbstractArray}

"""
Simulate the model, the parameters must have an evolution
rule to be simulated. 
Returns ODESolution (Unwrapped).
"""
function _simulate(
    params::AbstractEbmParams,
    u0::AbstractVector, tspan;
    solver_options...)
    rule = EvolutionRule(params)
    prob = ODEProblem(rule, u0, tspan, params)
    solve(prob, Tsit5(); solver_options...)
end

"""
Collect parameter to a dictionary of Symbol => T.
"""
function Base.collect(p::AbstractEbmParams)
    names = propertynames(p)
    return Dict(name => getproperty(p, name) for name in names)
end

"""
Pretty pritn for AbstractEbmParams
"""
function Base.show(io::IO, params::T) where {T<:AbstractEbmParams}
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
include("recipes.jl")
include("api-server.jl")
include("macros.jl")
include("example.jl")

"""
    check_routh_hurwitz(a0, a1, a2, a3, ...)

Check Routh-hurwitz stability for polynomial of order 1, 2, 3 and 4.
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
    update_params(params::AbstractEbmParams, updates::Vector{ParameterChange}...; kwargs...)

Convenience function to update parameters of the model. The model must implement `ParamsUpdater` interface.
"""
function update_params(
    params::AbstractEbmParams,
    updates::Vector{ParameterChange}...;
    kwargs...
)
    updater = ParamsUpdater(params)
    return updater(params, updates...; kwargs...)
end

import .Macros: @ebmspecs

public @ebmspecs
public AbstractEbmParams

end # module EbmCommon
