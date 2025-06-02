"""
A note:
- Legends and label kind of sucks in recipe
- I should probably write custom ploting function, just like 
  the previous UserApi.jl file.
- https://github.com/MakieOrg/Makie.jl/issues/4348
"""
MakieCore.plottype(::BifurcationData2d) = MakieCore.Heatmap
MakieCore.plottype(::BifurcationData1d) = BifurcationDiagram1d
MakieCore.plottype(::PhaseData2d) = PhasePortrait2d
#MakieCore.plottype(::SimulationResult) = CompartmentPlot

#= function MakieCore.convert_arguments( =#
#=     ::Type{MakieCore.Heatmap}, data::BifurcationData2d) =#
#=     xs = data.xvalues =#
#=     ys = data.yvalues =#
#=     zs = data.stability_map =#
#=     (xs, ys, zs) =#
#= end =#

@recipe(CompartmentPlot, data) do scene
    Attributes()
end

@recipe(BifurcationDiagram1d, data) do scene
    Attributes(
        k_samples=50,
        baseline_color=:red,
        labels=nothing,
        markersize=4,
    )
end

@recipe(PhasePortrait2d, data) do scene
    Attributes(
        orbit_color=:black,
        start_color=:blue,
        stop_color=:red,
    )
end

"""
Plot phase portrait recipe
"""
function Makie.plot!(
    plot::CompartmentPlot{Tuple{SimulationResult{T}}}
) where {T<:AbstractEbmParams}
    data = plot[1][]
    params = data.params
    solution = data.solution

    variables = get_variable_specifications(params)
    t = solution.t
    for (idx, variable) in variables
        x = map(u -> u[idx], solution.u)
        label = variable.description
        @show label
        lines!(plot, t, x; label=variable.description)
    end

    return plot
end

"""
Plot phase portrait recipe
"""
function Makie.plot!(
    p::PhasePortrait2d{Tuple{PhaseData2d{P,T,X,Y}}}
) where {P,T,X,Y}
    o = p[1][]

    xind = first(o.xchange)
    yind = first(o.ychange)
    for sol in o.solutions
        u = sol.u
        x = map(x -> x[xind], u)
        y = map(x -> x[yind], u)
        lines!(p, x, y; color=p.orbit_color)
    end

    for sol in o.solutions
        u = sol.u
        start = u[begin]
        stop = u[end]
        scatter!(p, [(start[xind], start[yind])], color=p.start_color)
        scatter!(p, [(stop[xind], stop[yind])], color=p.stop_color)
    end

    return p
end

"""
Recipe for bifurcation diagram 1D.
"""
function Makie.plot!(p::BifurcationDiagram1d{Tuple{EbmCommon.BifurcationData1d{P,T}}}) where {P,T}
    data::EbmCommon.BifurcationData1d = p[1][]
    param_name, param_values = data.change
    sols = data.solutions
    xbase = getproperty(data.base_params, param_name)
    k = p.k_samples[]
    n = EbmCommon.number_of_variables(data.base_params)

    # Map data to plot args
    labels = something(p.labels[], ["u$i" for i in 1:n])
    xs = Float64[]
    yss = [Float64[] for _ in 1:n]
    for (x, sol) in zip(param_values, sols)
        append!(xs, fill(x, k))
        for i in 1:n
            append!(yss[i], map(u -> u[i], sol.u)[end-k+1:end])
        end
    end

    # Plotting
    ymin = minimum(minimum(ys) for ys in yss)
    ymax = maximum(maximum(ys) for ys in yss)
    lines!([(xbase, ymin), (xbase, ymax)]; color=p.baseline_color)
    for (i, ys) in enumerate(yss)
        scatter!(p, xs, ys; markersize=p.markersize, label=labels[i])
    end

    return p
end

"""
Set default theme for Makie
"""
function set_makie_theme!(; fontsize=14)
    theme = Theme(
        figure_padding=2,
        fontsize=fontsize,
        markersize=7,
        CairoMakie=(
            antialias=:best,
            pt_per_unit=2.0,
            px_per_unit=2.0,
        ),
        Axis=(
            xticks=WilkinsonTicks(7, k_min=5, k_max=11),
            yticks=WilkinsonTicks(7, k_min=5, k_max=11),
            width=600, height=300,
            # aspect=21.0 / 9,
            pallete=Makie.wong_colors(),
        ),
        Axis3=(
            xticks=WilkinsonTicks(7, k_min=5, k_max=11),
            yticks=WilkinsonTicks(7, k_min=5, k_max=11),
            width=485, height=300,
            pallete=Makie.wong_colors(),
        ),
        Lines=(
            linewidth=2.5,
            linestyle=:solid,
        ),
    )


    theme = merge(theme, Makie.theme_latexfonts())
    set_theme!(theme)
    return theme
end

# High-level plotting function
function Makie.plot(data::PhaseData2d)
    @unpack params, xchange, ychange = data
    xind, yind = first(xchange), first(ychange)
    variables = get_variable_specifications(params)
    fig = Figure()
    ax = Axis(fig[1, 1],
        xlabel=variables[xind].description,
        ylabel=variables[yind].description
    )
    p = plot!(ax, data)
    resize_to_layout!(fig)
    return fig, ax, p
end

function Makie.plot(data::SimulationResult)
    fig = Figure()
    params = data.params
    model_specs::ModelSpecs = get_model_specifications(params)
    ax = Axis(fig[1, 1],
        xlabel=model_specs.time_axis_name,
        ylabel=model_specs.state_axis_name
    )
    params = data.params
    solution = data.solution

    variables = get_variable_specifications(params)
    t = solution.t
    plots = map(collect(variables)) do (idx, variable)
        x = map(u -> u[idx], solution.u)
        lines!(ax, t, x; label=variable.description)
    end

    axislegend(ax)
    resize_to_layout!(fig)

    return fig, ax, plots
end

"""
Draw theoretical local stability when changing 2 parameters.
"""
function Makie.plot(
    data::BifurcationData2d,
    horizontal_legend=false,
)
    # Unpack arguments
    @unpack base_params, xvalues, yvalues, stability_map, update_x, update_y = data
    xname = first(update_x)
    yname = first(update_y)
    param_specs = get_parameter_specifications(base_params)
    se = StabilityEncoder(base_params)

    # Mapping to categorical heatmap
    colormap = Makie.wong_colors()
    xlabel = param_specs[xname].description
    ylabel = param_specs[yname].description
    flags = convert.(UInt8, transpose(stability_map))
    cats = sort!(unique(flags))
    labels = [stability_flagname(se, flag) for flag in cats]
    colors = Makie.categorical_colors(colormap, length(cats))
    cat_ids::Matrix{Int} = something(indexin(flags, cats), -1)

    # Visualize
    fig = Figure(figure_padding=10)
    ax = Axis(fig[1, 1]; xlabel, ylabel)
    p = heatmap!(ax, xvalues, yvalues, cat_ids, colormap=colors)
    elements = [PolyElement(color=color) for color in colors]
    if horizontal_legend
        Legend(fig[2, 1], elements, labels, orientation=:horizontal)
    else
        Legend(fig[1, 2], elements, labels)
    end

    resize_to_layout!(fig)
    return fig, ax, p
end
