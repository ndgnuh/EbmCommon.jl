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
function plot_bifurcation_2d(
        data::Ebm.Bifurcation2d{T};
        horizontal_legend = false,
        colormap = Makie.wong_colors(),
        xlabel = get_latex_name(T, data.update_x[1]),
        ylabel = get_latex_name(T, data.update_y[1]),
    ) where {T}
    # Unpack arguments
    base_params = data.base_params
    stability_map = data.stability_map
    xvalues = data.xvalues
    yvalues = data.yvalues
    se = Ebm.StabilityEncoder(base_params)

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
additional options for plotting used by `plot_bifurcation_2d`.

See also: `run_bifurcation_2d`, `plot_bifurcation_2d`.
"""
function plot_bifurcation_2d(
        base_params::P,
        update_x::Pair{Symbol, T1},
        update_y::Pair{Symbol, T2};
        update_options = NamedTuple(),
        horizontal_legend = false,
        colormap = Makie.wong_colors(),
        xlabel = get_latex_name(P, update_x[1]),
        ylabel = get_latex_name(P, update_y[1]),
    ) where {P, T1, T2}
    # Run the bifurcation analysis
    data = run_bifurcation_2d(base_params, update_x, update_y, update_options)

    # Plot the results
    return plot_bifurcation_2d(data; horizontal_legend, colormap, xlabel, ylabel)
end

"""
Returns a LaTeX string with the names of the equilibria depending on the stability flag.

# Parameters

  - `se::StabilityEncoder{T}`: Stability encoder that contains the number of equilibria.
  - `flag::T`: Stability flag, an unsigned integer where each bit represents the stability of an equilibrium.
"""
function stability_flagname(se::Ebm.StabilityEncoder{T}, flag::T) where {T <: Unsigned}
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
