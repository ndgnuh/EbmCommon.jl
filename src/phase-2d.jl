@kwdef struct PhaseData2d{P<:AbstractEbmParams,T<:AbstractVector,ChangeX,ChangeY}
    # Input
    params::P
    u0::T
    xchange::Pair{Int,ChangeX}
    ychange::Pair{Int,ChangeY}
    tspan
    solver_options
    # Results
    xs
    ys
    solutions
end

"""
Run phase portrait (2D) of a system. 

See `DifferentialEquations` package documentation for more detail.
This function is just a wrapper for `DifferentialEquations`.

- evolution: Function!(du, u, params, t) or Function(u, params, t) -> du
- params: Model parameters
- u0: Vector
- xchange: pair of int -> values that specify change in x component,
- ychange: pair of int -> values that specify change in y component,
- solver: numerical solver (default to `Tsit5`)
- tspan: solver's tspan (default to `(0, 500)`)
- solver_options: solver's options
"""
function run_phase_portrait_2d(
    params::AbstractEbmParams,
    u0::AbstractVector,
    xchange::Pair{Int,ChangeX},
    ychange::Pair{Int,ChangeY};
    tspan=(0, 500.0),
    solver_options=NamedTuple(),
) where {ChangeX,ChangeY}

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
        simulate(params, u0_, tspan; solver_options...)
    end

    return PhaseData2d(;
        params, u0,
        xchange, ychange,
        xs, ys, solutions,
        tspan, solver_options
    )
end
