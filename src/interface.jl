const Vec = AbstractVector
const SVec = SVector

"An interface for all EBM model/parameters"
abstract type AbstractEbmParams end

"Default initial state"
function default_u0 end

"Default time span for simulation"
function default_tspan end

"Default tolerance of gradient for early stop"
function default_gradient_tol end

"Evolution operator for the model (immutable version)"
function evolve end

"Evolution operator for the model (mutable version)"
function evolve! end

"Number of equilibria in the model"
function number_of_equilibria end

"Get name of variables or parameters"
function get_latex_name end

"Get xlabel for plotting"
function get_xlabel end

"Get ylabel for plotting"
function get_ylabel end

"Get equilibria of the model"
function get_equilibria end

"Get local stabilities of the equilibria"
function get_local_stabilities end

"Get jacobian at a state"
function get_jacobian end

"Update parameters with new values"
function update end


# ===================
# Required interfaces
# ===================

@required AbstractEbmParams begin
    # Numerical solving
    default_u0(::AbstractEbmParams)
    default_tspan(::AbstractEbmParams)
    evolve(::Vec, ::AbstractEbmParams, ::Real)
    evolve!(::Vec, ::Vec, ::AbstractEbmParams, ::Real)

    # Specifications
    get_latex_name(::AbstractEbmParams, ::Symbol)
    get_latex_name(::AbstractEbmParams, ::Integer)
    get_latex_name(::AbstractEbmParams, ::Tuple)
    get_xlabel(::AbstractEbmParams)
    get_ylabel(::AbstractEbmParams)

    # Calculations
    get_jacobian(::AbstractEbmParams, ::Vec)
    get_equilibria(::AbstractEbmParams)
    get_local_stabilities(::AbstractEbmParams)
end

# ===================
# Optional interfaces
# ===================

"Number of compartments in the model"
number_of_variables(p::AbstractEbmParams) = length(p |> default_u0)

"Number of equilibria in the model"
number_of_equilibria(p::AbstractEbmParams) = length(p |> get_equilibria)

"Default ODE solver"
default_solver(::AbstractEbmParams) = Tsit5()

"Default ODE solver options"
default_solver_options(::AbstractEbmParams) = NamedTuple()

"Default gradient tolerance for early stopping"
default_gradient_tol(::AbstractEbmParams) = 0.7e-4

"""
$SIGNATURES

Returns the characteristic polynomial's coefficients for
the `i`-th equilibrium.
"""
function get_routh_hurwiz_coefficients(::T, i::Integer) where {T <: AbstractEbmParams}
    throw("$T does not implement $(@__FUNCTION__)")
end

"""
Returns Vector of symbols for updating parameters.

Useful for parameter aliases.
"""
const NTuplesOfSymbols = NTuple{N, Symbol} where {N}
function get_update_properties(::AbstractEbmParams, name::Symbol)::NTuplesOfSymbols
    return (name,)
end


"""
$TYPEDSIGNATURES

Update parameters to new values from base parameters.
Return new parameters instance, does not modify in place.

The callback can be used to perform additional operations
after the parameters have been updated, for example,
update parameters using custom dependent rules.
"""
function update(
        params::AbstractEbmParams,
        updates::Pair{Symbol}...;
        update_callback = nothing
    )
    for (k, v) in updates
        props = get_update_properties(params, k)
        for prop in props
            params = set(params, PropertyLens(prop), v)
        end
    end

    if isnothing(update_callback)
        return params
    else
        return update_callback(params)
    end
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
    return print(io, output)
end

"""
$SIGNATURES

Convert to copy-pastable latex code to show in documents.
"""
function to_latex(params::T) where {T <: AbstractEbmParams}
    names = propertynames(params)
    mapped = map(names) do name
        ltx_name = get_latex_name(params, name)
        getproperty(params, name)
        "$ltx_name &= $value"
    end

    return join(mapped, ", &")
end

"""
$TYPEDSIGNATURES

Autonomous version for the evolution operator. This is just 
a wrapper for `evolve` with `t = NaN`. Useful for working with
packages such as `BifurcationKit.jl`.
"""
function autonomous_evolve(u::AbstractVector, p::T) where {T <: AbstractEbmParams}
    return evolve(u, p, NaN)
end
