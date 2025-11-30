export plot_bifurcation_1d

"""
     $(TYPEDSIGNATURES)

Change 1 parameter of the model and plot the changes in the final outputs.

This function receives the same inputs of `run_bifurcation_1d` and of `plot_bifurcation_1d`.
The `kwargs` are passed to `plot_bifurcation_1d`.

See also: `run_bifurcation_1d`, `BifurcationData1d`.
"""
function plot_bifurcation_1d(
        params::T,
        u0::AbstractVector,
        change::Pair{Symbol};
        tspan = default_tspan(params),
        change_options = NamedTuple(),
        solver = get_default_solver(T),
        solver_options = get_default_solver_options(T),
        kwargs...,
    ) where {T}
    output = run_bifurcation_1d(
        params,
        u0,
        change;
        tspan = tspan,
        change_options = change_options,
        solver = solver,
        solver_options = solver_options,
    )
    return plot_bifurcation_1d(output; kwargs...)
end

"""
    $(SIGNATURES)

Plot the bifurcation diagram from `BifurcationData1d`.

# Parameters
- `data::Bifurcation1d{Params}`: Bifurcation data containing the results of the analysis.
  It should contain the following fields:

# Options

- `output_indices::Vector{Int}=[1]`: Indices of the output variables to be plotted.
- `output_labels::Vector{String}`: Labels for the output variables. If not provided, it will use the default variable names model.
- `ylabel::String=get_model_specifications(params).state_axis_name`: Label for the y-axis.
- `cutoff_at_the_end::Real=0.2`: Number of steps or fraction of steps of the end of the simulation to be cut off.
    If the value is an integer, it will be treated as the number of steps to cut off.
    If the value is a float, it will be treated as a fraction of the total steps to cut off.
- `baseline_color=:red`: Color of the baseline line indicating the parameter value.
- `baseline_linewidth=1`: Width of the baseline line.
- `markersize=2`: Size of the markers in the plot.
"""
function plot_bifurcation_1d(
        data::Bifurcation1d{Params};
        output_indices = [1],
        output_labels = [get_latex_name(Params, i) for i in output_indices],
        xlabel = get_latex_name(Params, first(data.change)),
        ylabel = get_ylabel(Params),
        cutoff_at_the_end::Real = 0.2,
        baseline_color = :red,
        baseline_linewidth = 1,
        markersize = 3,
    ) where {Params}
    # Unpack
    solutions = data.solutions
    change = data.change
    base_params = data.base_params
    param_name, param_values = change
    param_base_value = getproperty(base_params, param_name)

    # Transform simulation data to plotting data
    xs = Float64[]
    yss = [Float64[] for _ in output_indices]
    for (param_value, sol) in zip(param_values, solutions)
        # How many steps to cut off
        t = sol.t
        cutoff_step = if cutoff_at_the_end isa Integer
            cutoff_at_the_end
        else
            floor(Int, cutoff_at_the_end * length(t))
        end

        # Pad the x values to even the cutoff length
        append!(xs, fill(param_value, cutoff_step))

        # Collect the output values from cutoff point
        for i in output_indices
            y = get_compartment(sol.u, i)
            append!(yss[i], y[(end - cutoff_step + 1):end])
        end
    end

    # Create the figure
    fig = Figure()
    ax = Axis(fig[1, 1]; xlabel, ylabel)

    # Draw the fluctuations of output variables
    for (i, ys) in enumerate(yss)
        label = output_labels[output_indices[i]]
        scatter!(ax, xs, ys; markersize = markersize, label = label)
    end

    # Draw the baseline of parameter value
    ymin = minimum(minimum(ys) for ys in yss)
    ymax = maximum(maximum(ys) for ys in yss)
    lines!(
        [(param_base_value, ymin), (param_base_value, ymax)];
        color = baseline_color,
        linewidth = baseline_linewidth,
    )

    resize_to_layout!(fig)
    axislegend(ax)

    return fig
end

function plot_bifurcation_1d(;
        params::T,
        change::Pair{Symbol},
        u0::Vector = default_u0(params),
        tspan = default_tspan(params),
        change_options = NamedTuple(),
        solver = get_default_solver(T),
        solver_options = get_default_solver_options(T),
    ) where {T <: AbstractEbmParams}
    return plot_bifurcation_1d(
        params::T,
        u0::Vector,
        change::Pair{Symbol};
        tspan = (0.0, 1000.0),
        change_options = NamedTuple(),
        solver = get_default_solver(T),
        solver_options = get_default_solver_options(T),
        kwargs...,
    )
end
