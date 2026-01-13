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

function Base.show(io::IO, br::Bifurcation1d)
    name = first(br.config.param_updates)
    values = last(br.config.param_updates)
    pmin, pmax = minimum(values), maximum(values)
    println(io, "Bifurcation1dResult:")
    println(io, "\tparam: [$name] $pmin → $pmax")
    for bp in br.bifurcation_points
        lb, ub = bp.interval
        println(io, "\t$(bp.type): $(bp.param) [$lb, $ub]")
    end
    return
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

    # U0 is changed after the simulation
    # So copying it and re-initialize every time
    # Run simulation for the final state
    base_u0 = copy(u0)
    updated_params = typeof(base_params)[]
    solutions = ODESolution[]
    callback = TerminateSteadyState(1.0e-4)

    let n = length(param_values)
        sizehint!(updated_params, n)
        sizehint!(solutions, n)
    end
    for value in param_values
        # Update parameter
        params = update(
            base_params, param_name => value;
            update_callback
        )

        # Get tspan and solver options based on the value
        # of bifurcation parameter
        tspan_ = tspan isa Function ? tspan(value) : tspan
        solver_options_ = if solver_options isa Function
            solver_options(value)
        else
            solver_options
        end

        # eayly stop when steady state reached
        solver_options_ = merge(
            solver_options_, (; callback = callback)
        )

        # Reset u0 and re-run simulation
        u0 = copy(base_u0)
        sol = _simulate(
            params, u0, tspan;
            solver, solver_options = solver_options_
        )

        # Store states
        push!(updated_params, params)
        push!(solutions)
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
