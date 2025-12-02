@kwdef struct StabilityDiagramOptions{S1, S2}
    horizontal_legend::Bool = false
    colormap = Makie.wong_colors()
    xlabel::S1
    ylabel::S2
end

function StabilityDiagramOptions(
        config::Ebm.Bifurcation2dConfig;
        kwargs...,
    )
    params = config.params
    x_name = first(config.x_updates)
    y_name = first(config.y_updates)
    xlabel = get_latex_name(params, x_name)
    ylabel = get_latex_name(params, y_name)
    return StabilityDiagramOptions(; xlabel, ylabel, kwargs...)
end

"""
$(TYPEDSIGNATURES)

Plot the local stability of a 2D "bifurcation" analysis.

# Parameters & Options

- `data::Bifurcation2d`: The bifurcation data containing the stability map and parameter values.
- `horizontal_legend = false`: If true, the legend is displayed horizontally.
- `colormap = Makie.wong_colors()`: The colormap used for the heatmap.
- `xlabel = get_latex_name(T, data.update_x[1])`: Label for the x-axis, defaults to the LaTeX name of the first parameter.
- `ylabel = get_latex_name(T, data.update_y[1])`: Label for the y-axis, defaults to the LaTeX name of the second parameter.
"""
function plot_stability_diagram(
        data::Ebm.Bifurcation2d{T},
        config = StabilityDiagramOptions(data.config)
    ) where {T}

    # Unpack arguments
    base_params = data.config.params
    stability_map = data.stabilities
    xvalues = data.config.x_updates[end]
    yvalues = data.config.y_updates[end]
    se = StabilityEncoder(base_params)

    @unpack (
        horizontal_legend,
        colormap,
        xlabel,
        ylabel,
    ) = config

    # Mapping to categorical heatmap
    flags = convert.(UInt8, stability_map)
    cats = sort!(unique(flags))
    labels = [stability_flagname(se, flag) for flag in cats]
    colors = Makie.categorical_colors(colormap, length(cats))
    cat_ids::Matrix{Int} = something(indexin(flags, cats), -1)

    # Visualize
    fig = Figure()
    ax = Axis(fig[1, 1]; xlabel, ylabel)
    heatmap!(ax, xvalues, yvalues, cat_ids; colormap = colors)
    elements = [PolyElement(; color = color) for color in colors]
    if horizontal_legend
        Legend(fig[2, 1], elements, labels; orientation = :horizontal)
    else
        Legend(fig[1, 2], elements, labels)
    end

    resize_to_layout!(fig)
    return fig
end

"""
$(TYPEDSIGNATURES)

Convenience function to run and plot 2d bifurcation analysis experiment.

The parameters are the same as in `run_bifurcation_2d`, but it also accepts
additional options for plotting used by `plot_stability_diagram`.

See also: `run_bifurcation_2d`, `plot_stability_diagram`.
"""
function plot_stability_diagram(
        base_params::AbstractEbmParams,
        update_x::Pair{Symbol},
        update_y::Pair{Symbol};
        kwargs...
    )
    # Run the bifurcation analysis
    config = construct_from_kwargs(
        Ebm.Bifurcation2dConfig,
        params = base_params,
        x_updates = update_x,
        y_updates = update_y,
        kwargs...,
    )
    data = run_bifurcation_2d(config)
    visualization_config = construct_from_kwargs(
        StabilityDiagramOptions, config,
        kwargs...,
    )

    # Plot the results
    return plot_stability_diagram(data, visualization_config)
end

"""
Returns a LaTeX string with the names of the equilibria depending on the stability flag.

# Parameters

  - `se::StabilityEncoder{T}`: Stability encoder that contains the number of equilibria.
  - `flag::T`: Stability flag, an unsigned integer where each bit represents the stability of an equilibrium.
"""
function stability_flagname(se::StabilityEncoder{T}, flag::T) where {T <: Unsigned}
    baseflag = one(flag)
    n = se.num_equilibria
    stabily_names = String[]
    sizehint!(stabily_names, n)
    for k in 1:n
        if (flag & baseflag) != 0
            push!(stabily_names, "E_$k")
        end
        baseflag = baseflag << 1
    end
    name = join(stabily_names, ", ")
    if isempty(name)
        return L"\varnothing"
    else
        return Makie.LaTeXString(name)
    end
end
