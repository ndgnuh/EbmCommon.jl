using BifurcationKit

"$(SIGNATURES)"
@kwdef struct Bifurcation1dConfig{T}
    "Simulation configuration"
    simulation_config::SimulationConfig{T}
    "Parameter to be updated"
    param_updates::Pair{Symbol}
    "Extra update callback, if any"
    update_callback = nothing
    "Bifurcation algorithm"
    continuation_alg = PALC()
    "Options for ContinuationPar"
    continuation_options = NamedTuple()
end

"""
$(SIGNATURES)
"""
@kwdef struct Bifurcation1d{Params <: AbstractEbmParams, T}
    "Bifurcation config"
    config::Bifurcation1dConfig{Params}
    "Altered parameters"
    updated_params::Vector{Params}
    "Solved solutions"
    solutions::Vector{ODESolution}
    "bifurcation points"
    bifurcation_points::Vector{T}
end

"""
$(SIGNATURES)

Run a bifurcation analysis for a 1D system.
Returns a `Bifurcation1d` object containing the results.

See also: `plot_bifurcation_1d`, `Bifurcation1d`.
"""
function run_bifurcation_1d(config::Bifurcation1dConfig{T}) where {T}
    @unpack (
        param_updates, update_callback, simulation_config,
        continuation_alg, continuation_options,
    ) = config
    @unpack params, u0, tspan, solver, solver_options, gradient_tol = simulation_config

    # Data
    param_name, param_values = param_updates
    param_min = minimum(param_values)
    param_max = maximum(param_values)
    base_params = params
    param_base = getproperty(params, param_name)

    @assert param_min < param_base < param_max "Initial bifurcation parameter value $param_name = $param_base must be within bounds [$param_min, $param_max]."

    # Run simulation for the final state
    updated_params = map(param_values) do value
        update(base_params, param_name => value; update_callback)
    end
    solutions::Vector{ODESolution} = map(updated_params) do params_
        _simulate(params_, u0, tspan; solver, solver_options)

    end

    # Solve numerical bifurcation for branching points
    bp = BifurcationProblem(
        autonomous_evolve,
        u0, params, PropertyLens(param_name),
    )
    cont_param = ContinuationPar(
        p_min = param_min,
        p_max = param_max,
        continuation_options...
    )
    br = continuation(bp, continuation_alg, cont_param)

    return Bifurcation1d(;
        config, updated_params, solutions,
        bifurcation_points = bifurcation_points(br)
    )
end

"""
$(SIGNATURES)
"""
function run_bifurcation_1d(
        params::T;
        param_updates,
        u0 = default_u0(params),
        tspan = default_tspan(params),
        solver = default_solver(params),
        solver_options = default_solver_options(params),
        gradient_tol = default_gradient_tol(params),
        update_callback = nothing,
    ) where {T}
    simulation_config = SimulationConfig(;
        params, u0, tspan, solver,
        solver_options, gradient_tol,
    )
    config = Bifurcation1dConfig(;
        simulation_config,
        param_updates, update_callback
    )
    return run_bifurcation_1d(config)
end
