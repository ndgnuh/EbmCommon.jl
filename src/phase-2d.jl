export PhasePortrait2d, run_phase_portrait_2d

"""
Struct to hold data for 2D phase portrait.

# Properties

  - `params`: Model parameters
  - `u0`: Initial conditions vector
  - `xchange`: Pair of (`xindex`, `xvalues`) that specify change in `index`-th component.
  - `ychange`: Pair of (`yindex`, `yvalues`) that specify change in `index`-th component.
  - `tspan`: Time span for the simulation
  - `solver_options`: Options for the numerical ODE solver
  - `xs`: x-coordinates of the solved orbits
  - `ys`: y-coordinates of the solved orbits
  - `solver`: ODE solver used for the simulation
  - `solutions`: List of ODESolutions for each point in the grid

See also: `run_phase_portrait_2d`.
"""
@kwdef struct PhasePortrait2d{P <: AbstractEbmParams, T1, T2}
    # Input
    params::P
    u0::Vector
    xchange::Pair{Int, T1}
    ychange::Pair{Int, T2}
    tspan::Any
    solver::Any
    solver_options::Any
    # Results
    xs::Any
    ys::Any
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
  - `xchange`: Pair of (`xindex`, `xvalues`) that specify change in `index`-th component.
  - `ychange`: Pair of (`yindex`, `yvalues`) that specify change in `index`-th component.

# Options

  - `tspan`: Time span for the simulation, default is `(0, 500.0)`.
  - `solver_options`: Options for the numerical ODE solver, default is an empty `NamedTuple`.

See also: `PhasePortrait2d`, `DifferentialEquations.solve`.
"""
function run_phase_portrait_2d(
    params::T,
    u0::AbstractVector,
    xchange::Pair{Int, ChangeX},
    ychange::Pair{Int, ChangeY};
    tspan = (0, 500.0),
    solver = get_default_solver(T),
    solver_options = get_default_solver_options(T),
) where {T, ChangeX, ChangeY}

    # Grid where extrema rules
    xind, xvals = xchange
    yind, yvals = ychange
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
        params,
        u0,
        xchange,
        ychange,
        xs,
        ys,
        solutions,
        tspan,
        solver,
        solver_options,
    )
end
