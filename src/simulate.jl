@kwdef struct SimulationResult{T<:AbstractEbmParams}
    params::T
    u0::Vector{Float64}
    solution::ODESolution
    tspan
    solver_options = NamedTuple()
end

"""
Simulate the model, the parameters must have an evolution
rule to be simulated.

Returns SimulationResult (Wrapped) to help with plotting.
"""
function simulate(
    params::AbstractEbmParams,
    u0::AbstractVector, tspan;
    solver_options...
)
    solution = _simulate(params, u0, tspan; solver_options...)
    return SimulationResult(;
        params, u0, tspan, solution, solver_options)
end

