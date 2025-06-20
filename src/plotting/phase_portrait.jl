export plot_phase_portrait

"""
$(TYPEDSIGNATURES)

Plots the phase portrait of a 2D system. Returns a `Figure` object containing the phase portrait.

# Parameters
- `data::PhasePortrait2d{T}`: The simulation result after runnning phase portrait experiment.

# Options

- `orbit_color`: Color of the orbit lines, default is `:black`.
- `orbit_alpha`: Transparency of the orbit lines, default is `0.5`.
- `orbit_linewidth`: Width of the orbit lines, default is `2`.
- `orbit_linestyle`: Style of the orbit lines (e.g., `:solid`, `:dash`), default is `:solid`.
- `show_start_marker`: Whether to show the start marker for each orbit, default is `true`.
- `show_stop_marker`: Whether to show the stop marker for each orbit, default is `true`.
- `show_limit_cycle`: Whether to show the limit cycle orbit, default is `false`, only applies if the simulation contains limit cycle.
- `marker_size`: Common size for markers, default is `2`.
- `start_marker_size`: Size of the start marker, default is `marker_size`.
- `start_marker_color`: Color of the start marker, default is `:blue`.
- `stop_marker_size`: Size of the stop marker, default is `marker_size`.
- `stop_marker_color`: Color of the stop marker, default is `:red`.
- `limit_cycle_linewidth`: Width of the limit cycle orbit line, default is `2`.
- `limit_cycle_linestyle`: Style of the limit cycle orbit line, default is `:solid`.
- `limit_cycle_color`: Color of the limit cycle orbit line, default is `:red`.
- `limit_cycle_start`: The starting point for the limit cycle orbit, can be an integer index or a fraction of the total length of the orbit, default is `0.2`.

See also: `PhasePortrait2d`, `run_phase_portrait_2d`.
"""
function plot_phase_portrait(
    data::PhasePortrait2d{T};
    orbit_color = :black,
    orbit_alpha = 0.5,
    orbit_linewidth = 2.0,
    orbit_linestyle = :solid,
    show_start_marker::Bool = true,
    show_stop_marker::Bool = true,
    show_limit_cycle = false,
    marker_size = 2,
    start_marker_size = marker_size,
    start_marker_color = :blue,
    stop_marker_size = marker_size,
    stop_marker_color = :red,
    limit_cycle_linewidth = 2.0,
    limit_cycle_linestyle = :solid,
    limit_cycle_color = :red,
    limit_cycle_start::Real = 0.2,
) where {T}
    fig = Figure()

    # Unpack data
    params = data.params
    solutions = data.solutions
    xindex, xvalues = data.change_x
    yindex, yvalues = data.change_y

    # Collect orbits' xs and ys
    xs = Vector{Float64}[]
    ys = Vector{Float64}[]
    sizehint!(xs, length(solutions))
    sizehint!(ys, length(solutions))
    for solution in solutions
        u = solution.u
        push!(xs, map(u -> u[xindex], u))
        push!(ys, map(u -> u[yindex], u))
    end

    # Get information from the model
    xlabel = get_latex_name(params, xindex)
    ylabel = get_latex_name(params, yindex)

    # Create the axis to draw
    ax = Axis(fig[1, 1]; xlabel = xlabel, ylabel = ylabel)

    # Plot the orbits
    for solution in solutions
        u = solution.u
        x = map(u -> u[xindex], u)
        y = map(u -> u[yindex], u)

        # Plot the orbit
        lines!(
            ax,
            x,
            y;
            color = (orbit_color, orbit_alpha),
            linewidth = orbit_linewidth,
            linestyle = orbit_linestyle,
        )
    end

    # Plot the start marker
    if show_start_marker
        for i in eachindex(solutions)
            x, y = xs[i], ys[i]

            scatter!(
                ax,
                [(x[1], y[1])];
                color = start_marker_color,
                markersize = start_marker_size,
            )
        end
    end

    # Plot the stop marker if requested
    if show_stop_marker
        for i in eachindex(solutions)
            x, y = xs[i], ys[i]

            scatter!(
                ax,
                [(x[end], y[end])];
                color = stop_marker_color,
                markersize = stop_marker_size,
            )
        end
    end

    # Plot the limit cycle orbit if requested
    if show_limit_cycle
        for i in eachindex(solutions)
            x, y = xs[i], ys[i]

            # calculate cutoff index for limit cycle
            # If `limit_cycle_start` is an integer,
            # it is used as the index.
            # else, it is a fraction of the total length of the orbit.
            cutoff_index = if limit_cycle_start isa Integer
                limit_cycle_start
            else
                floor(Int, limit_cycle_start * length(x))
            end

            lines!(
                ax,
                x[cutoff_index:end],
                y[cutoff_index:end];
                color = limit_cycle_color,
                linewidth = limit_cycle_linewidth,
                linestyle = limit_cycle_linestyle,
            )
        end
    end

    # Finish the figure layout
    axislegend(ax)
    resize_to_layout!(fig)
    return fig
end

"""

$(TYPEDSIGNATURES)

A convenience function to run and plot a 2D phase portrait.

The parameters are the same as in `run_phase_portrait_2d`.
After running, it calls `plot_phase_portrait` to visualize the results.
The keyword options `kwargs...` are passed to `plot_phase_portrait`.

See also: `run_phase_portrait_2d`, `plot_phase_portrait`.
"""
function plot_phase_portrait(
    params::P,
    u0::Vector,
    xchange::Pair{Int, T1},
    ychange::Pair{Int, T2};
    tspan = (0, 500.0),
    solver_options = NamedTuple(),
    kwargs...,
) where {P, T1, T2}
    data = run_phase_portrait_2d(
        params,
        u0,
        xchange,
        ychange;
        tspan = tspan,
        solver_options = solver_options,
    )
    return plot_phase_portrait(data; kwargs...)
end
