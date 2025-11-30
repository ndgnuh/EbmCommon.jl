export plot_compartments

@kwdef struct CompartmentPlotConfig{T <: Ebm.AbstractEbmParams}
    params::T
    xlabel = Ebm.get_xlabel(params)
    ylabel = Ebm.get_ylabel(params)
    output_indices = 1:Ebm.number_of_variables(params)
    linestyle = :solid
    colormap = Makie.wong_colors()
    legend_position = (:right, :top)
    labels = map(name -> Ebm.get_latex_name(params, name), output_indices)
    scale = nothing
    fig = Figure()
    ax = Axis(fig[1, 1]; xlabel, ylabel)
end

"""
$TYPEDSIGNATURES

Plot compartment simulation results using Makie.

Options: $(options_for(CompartmentPlotConfig))
"""
function plot_compartments(
        result::SimulationResult{T}; kwargs...
    ) where {T <: AbstractEbmParams}
    # Unpack the data
    params = result.config.params
    solution = result.solution
    @unpack u, t = solution

    # Create configuration
    config = construct_from_kwargs(CompartmentPlotConfig; params, kwargs...)
    @unpack (
        fig, ax, output_indices, linestyle, colormap,
        legend_position, labels, scale,
    ) = config


    # Draw the compartments
    for (i, (idx, label)) in enumerate(zip(output_indices, labels))
        linestyle_ = if linestyle isa AbstractVector
            linestyle[i]
        else
            linestyle
        end

        x = if scale isa Function
            scale.(get_compartment(u, idx))
        else
            get_compartment(u, idx)
        end
        lines!(ax, t, x; label, linestyle = linestyle_, colormap = colormap)
    end

    # Finish the plot
    axislegend(ax; position = legend_position)
    resize_to_layout!(fig)

    return fig
end

function plot_compartments(params::T; kwargs...) where {T}
    config = construct_from_kwargs(Ebm.SimulationConfig; params, kwargs...)
    result = Ebm.simulate(config)
    return plot_compartments(result; kwargs...)
end
