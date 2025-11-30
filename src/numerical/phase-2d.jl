export PhasePortrait2d, run_phase_portrait_2d, PhasePortrait2dConfig

@kwdef struct PhasePortrait2dConfig{P <: AbstractEbmParams}
    simulation_config::SimulationConfig{P}
    x_updates::Pair
    y_updates::Pair
end

"""
Struct to hold data for 2D phase portrait.

# Properties

  - `params`: Model parameters
  - `u0`: Initial conditions vector
  - `x_updates`: Pair of (`xindex`, `xvalues`) that specify change in `index`-th component.
  - `y_updates`: Pair of (`yindex`, `yvalues`) that specify change in `index`-th component.
  - `tspan`: Time span for the simulation
  - `solver_options`: Options for the numerical ODE solver
  - `xs`: x-coordinates of the solved orbits
  - `ys`: y-coordinates of the solved orbits
  - `solver`: ODE solver used for the simulation
  - `solutions`: List of ODESolutions for each point in the grid

See also: `run_phase_portrait_2d`.
"""
@kwdef struct PhasePortrait2d{P <: AbstractEbmParams}
    config::PhasePortrait2dConfig{P}
    initial_xs::Any
    initial_ys::Any
    solutions::Any
end

"""
Change two input components of the initial conditions and run the model
to give a 2D phase portrait of the model. Returns `PhasePortrait2d` struct.

See `DifferentialEquations` package documentation for more detail.
This function is just a wrapper for `DifferentialEquations`.

# Parameters

  - `params`: Model parameters of type `T`, where the method `EvolutionRule(::Type{T})` is defined.
  - `u0`: Initial conditions vector.
  - `x_updates`: Pair of (`xindex`, `xvalues`) that specify change in `index`-th component.
  - `y_updates`: Pair of (`yindex`, `yvalues`) that specify change in `index`-th component.

# Options

  - `tspan`: Time span for the simulation, default is `(0, 500.0)`.
  - `solver_options`: Options for the numerical ODE solver, default is an empty `NamedTuple`.

See also: `PhasePortrait2d`, `DifferentialEquations.solve`.
"""
function run_phase_portrait_2d(
        config::PhasePortrait2dConfig{T}
    ) where {T}

    @unpack simulation_config, x_updates, y_updates = config
    @unpack params, u0, tspan, solver, solver_options = simulation_config

    # Grid where extrema rules
    xind, xvals = x_updates
    yind, yvals = y_updates
    xmin, xmax = extrema(xvals)
    ymin, ymax = extrema(yvals)
    grid = @chain begin
        Iterators.product(xvals, yvals)
        Iterators.filter(_) do (x, y)
            x == xmin || x == xmax || y == ymin || y == ymax
        end
        Iterators.flatten((_,))
    end

    xs = map(first, grid)
    ys = map(last, grid)
    solutions = map(grid) do (x, y)
        u0_ = copy(u0)
        u0_[xind] = x
        u0_[yind] = y
        _simulate(params, u0_, tspan; solver, solver_options)
    end

    return PhasePortrait2d(;
        config,
        initial_xs = xs,
        initial_ys = ys,
        solutions,
    )
end

function run_phase_portrait_2d(
        params::T,
        u0::AbstractVector,
        x_updates::Pair{Int, ChangeX},
        y_updates::Pair{Int, ChangeY};
        tspan = default_tspan(params),
        solver = default_solver(params),
        solver_options = default_solver_options(params),
    ) where {T, ChangeX, ChangeY}
    sim_config = SimulationConfig{T}(;
        params,
        u0,
        tspan,
        solver,
        solver_options,
    )

    config = PhasePortrait2dConfig{T}(;
        sim_config,
        x_updates,
        y_updates,
    )
    return run_phase_portrait_2d(config)
end

"""
$(TYPEDSIGNATURES)
"""
function run_phase_portrait_2d(
        params::T;
        x_updates::Pair{Int, ChangeX},
        y_updates::Pair{Int, ChangeY},
        u0::AbstractVector = default_u0(params),
        tspan = default_tspan(params),
        solver = default_solver(params),
        solver_options = default_solver_options(params),
    ) where {T, ChangeX, ChangeY}
    sconfig = SimulationConfig{T}(;
        params,
        u0,
        tspan,
        solver,
        solver_options,
    )
    config = PhasePortrait2dConfig{T}(;
        simulation_config = sconfig,
        x_updates, y_updates,
    )
    return run_phase_portrait_2d(config)
end
