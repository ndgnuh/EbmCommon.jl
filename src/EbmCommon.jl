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

abstract type AbstractEbmParams end

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
end

const FloatType = Float64
const ParameterChange = Pair{Symbol,T} where {T<:AbstractArray}

"""
Simulate the model, the parameters must have an evolution
rule to be simulated.
"""
function simulate(
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

include("bifurcation-1d.jl")
include("bifurcation-2d.jl")
include("phase-2d.jl")
include("recipes.jl")
include("example.jl")

end # module EbmCommon
