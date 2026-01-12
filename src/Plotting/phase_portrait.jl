@kwdef struct PhasePortraitPlotOptions{T}
    data::PhasePortrait2d{T}
    orbit_color = :black
    orbit_alpha = 0.5
    orbit_linewidth = 2.0
    orbit_linestyle = :solid
    show_start_marker::Bool = true
    show_stop_marker::Bool = true
    show_limit_cycle = false
    marker_size = 10
    start_marker_size = marker_size
    start_marker_color = :blue
    stop_marker_size = marker_size
    stop_marker_color = :red
    limit_cycle_linewidth = 2.0
    limit_cycle_linestyle = :solid
    limit_cycle_color = :red
    limit_cycle_start::Real = 0.2
    xindex = data.config.x_updates[1]
    yindex = data.config.y_updates[1]
    xlabel = get_latex_name(data.config.simulation_config.params, xindex)
    ylabel = get_latex_name(data.config.simulation_config.params, yindex)
    fig = Figure()
    ax = Axis(fig[1, 1]; xlabel, ylabel)
end

"""
$TYPEDSIGNATURES

Plots the phase portrait of a 2D system. Returns a `Figure` object containing the phase portrait.

# Parameters
- `data::PhasePortrait2d{T}`: The simulation result after runnning phase portrait experiment.

# Options

- `orbit_color`: Color of the orbit lines, default is `:black`, a vector can be used to specify different colors for each orbit.
- `orbit_alpha`: Transparency of the orbit lines, default is `0.5`.
- `orbit_linewidth`: Width of the orbit lines, default is `2`.
- `orbit_linestyle`: Style of the orbit lines (e.g., `:solid`, `:dash`), default is `:solid`.
- `show_start_marker`: Whether to show the start marker for each orbit, default is `true`.
- `show_stop_marker`: Whether to show the stop marker for each orbit, default is `true`.
- `show_limit_cycle`: Whether to show the limit cycle orbit, default is `false`, only applies if the simulation contains limit cycle.
- `marker_size`: Common size for markers, default is `10`.
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
        config::PhasePortraitPlotOptions = PhasePortraitPlotOptions(; data),
    ) where {T}

    # Unpack data
    solutions = data.solutions
    @unpack (
        fig,
        ax,
        xindex,
        yindex,
        orbit_color,
        orbit_alpha,
        orbit_linewidth,
        orbit_linestyle,
        show_start_marker,
        show_stop_marker,
        show_limit_cycle,
        start_marker_size,
        start_marker_color,
        stop_marker_size,
        stop_marker_color,
        limit_cycle_linewidth,
        limit_cycle_linestyle,
        limit_cycle_color,
        limit_cycle_start,
    ) = config

    # Collect orbits' xs and ys
    xs = Vector{Float64}[]
    ys = Vector{Float64}[]
    sizehint!(xs, length(solutions))
    sizehint!(ys, length(solutions))
    for solution in solutions
        push!(xs, get_compartment(solution.u, xindex))
        push!(ys, get_compartment(solution.u, yindex))
    end

    # Plot the orbits
    for i in eachindex(solutions)
        x = xs[i]
        y = ys[i]

        color = if (orbit_color isa AbstractVector || orbit_color isa Tuple)
            (orbit_color[i], orbit_alpha)
        else
            (orbit_color, orbit_alpha)
        end

        # Plot the orbit
        lines!(ax, x, y; color, linewidth = orbit_linewidth, linestyle = orbit_linestyle)
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
function plot_phase_portrait(params::AbstractEbmParams; kwargs...)
    simulation_config = construct_from_kwargs(
        Ebm.SimulationConfig;
        params = params,
        kwargs...,
    )

    config = construct_from_kwargs(
        Ebm.PhasePortrait2dConfig;
        simulation_config,
        params = params,
        kwargs...
    )

    data = run_phase_portrait_2d(config)
    config = construct_from_kwargs(
        PhasePortraitPlotOptions;
        data = data,
        kwargs...,
    )

    return plot_phase_portrait(data, config)
end
