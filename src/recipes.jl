MakieCore.plottype(::BifurcationData2d) = MakieCore.Heatmap
MakieCore.plottype(::BifurcationData1d) = BifurcationDiagram1d
MakieCore.plottype(::PhaseData2d) = PhasePortrait2d

function MakieCore.convert_arguments(
    ::Type{MakieCore.Heatmap}, data::BifurcationData2d)
    xs = data.xvalues
    ys = data.yvalues
    zs = data.stability_map
    (xs, ys, zs)
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


function Makie.plot!(
    p::PhasePortrait2d{Tuple{PhaseData2d{P,T,X,Y}}}
) where {P,T,X,Y}
    o = p[1][]

    for sol in o.solutions
        u = sol.u
        x = map(x -> x[1], u)
        y = map(x -> x[2], u)
        lines!(p, x, y; color=p.orbit_color)
    end

    for sol in o.solutions
        u = sol.u
        start = Tuple(u[begin])
        stop = Tuple(u[end])
        scatter!(p, [start], color=p.start_color)
        scatter!(p, [stop], color=p.stop_color)
    end

    return p
end

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
