"""
A wrapper for the simulation result of an ODE problem.

### Properties

  - `params::T`: The parameters used for the simulation.
  - `u0::Vector{Float64}`: Initial conditions for the simulation.
  - `solution::ODESolution`: The solution of the ODE problem.
  - `tspan`: Time span of the simulation.
  - `solver_options`: Options used by the ODE solver.

See also: `simulate`, `ODESolution`, `AbstractEbmParams`.
"""
@kwdef struct SimulationResult{T <: AbstractEbmParams}
    params::T
    u0::Vector{Float64}
    solution::ODESolution
    tspan::Any
    solver_options = get_default_solver_options(T)
end

"""
$(SIGNATURES)

Simulate the model, the parameters must have an evolution
rule to be simulated, returns a `SimulationResult`.

The parameters must implements: `EvolutionRule` for this
function to work.

See also: `ODESolution`, `SimulationResult`.
"""
function simulate(
    params::T,
    u0::AbstractVector,
    tspan;
    solver = get_default_solver(T),
    solver_options = get_default_solver_options(T),
) where {T}
    solution = _simulate(params, u0, tspan; solver, solver_options)
    return SimulationResult(; params, u0, tspan, solution, solver_options)
end
