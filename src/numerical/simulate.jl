@kwdef struct SimulationConfig{T}
    params::T
    u0 = default_u0(params)
    tspan = default_tspan(params)
    solver = default_solver(params)
    solver_options = default_solver_options(params)
    gradient_tol = default_gradient_tol(params)
end

"""
Simulate the model, the parameters must have an evolution
rule to be simulated.

Returns `ODESolution` (Unwrapped).

See `DifferentialEquations` package documentation for more detail.
"""
function _simulate(
        params::T,
        u0::AbstractVector = default_u0(params),
        tspan = default_tspan(params);
        solver = Tsit5(),
        solver_options::NamedTuple = NamedTuple(),
        callback = nothing,
    ) where {T}
    prob = ODEProblem(evolve!, u0, tspan, params)

    options = if isnothing(callback)
        solver_options
    else
        (; callback, solver_options...)
    end
    return solve(prob, solver; options...)
end

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
    config::SimulationConfig{T}
    solution::ODESolution
end

function simulate(config::SimulationConfig)
    params = config.params
    u0 = config.u0
    tspan = config.tspan
    solver = config.solver
    solver_options = config.solver_options
    gradient_tol = config.gradient_tol

    callback = TerminateSteadyState(gradient_tol)
    solution = _simulate(params, u0, tspan; solver, solver_options, callback)
    return SimulationResult(; config, solution)
end

"""
$(SIGNATURES)

Simulate the model, the parameters must have an evolution
rule to be simulated, returns a `SimulationResult`.
"""
function simulate(params; kwargs...)
    config = construct_from_kwargs(SimulationConfig; params, kwargs...)
    return simulate(config)
end


"""
$(SIGNATURES)

Options: $(fieldnames(SimulationConfig))
"""
function simulate(; kwargs...)
    config = SimulationConfig(; kwargs...)
    return simulate(config)
end
