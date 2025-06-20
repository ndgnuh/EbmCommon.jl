const BIFURCATION_DIAGRAM_1D_DOC = """
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

"""
     $(SIGNATURES)

Change 1 parameter of the model and plot the changes in the final outputs.

### Parameters
- `params::AbstractEbmParams`: Parameters of the model.
- `u0::Vector`: Initial condition for the system.
- `change::Pair{Symbol}`: A pair of (parameter name, parameter values) indicate the parameter to be varied
    when drawing the bifurcation diagram. Parameter values should be a vector or an iterable collection of values.

### Options

- `tspan=(0.0, 1000.0)`: Time span for the simulation.
$(BIFURCATION_DIAGRAM_1D_DOC)
"""
function plot_bifurcation_diagram_1d(
    params,
    u0::Vector,
    change::Pair{Symbol};
    tspan=(0.0, 1000.0),
    output_indices::Vector=[1],
    output_labels::Vector=get_latex_name.(params, output_indices),
    xlabel::String=get_latex_name(params, first(change)),
    ylabel::String=get_ylabel(params),
    cutoff_at_the_end::Real=0.2,
    baseline_color=:red,
    baseline_linewidth=1,
    markersize=3,
    kwargs...,
)

    # Run
    output = run_bifurcation_1d(params, u0, change; tspan=tspan, kwargs...)
    solutions = output.solutions

    # Get information from model
    n = number_of_variables(params)

    # Unpack
    param_name, param_values = change
    param_base_value = getproperty(params, param_name)

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
        u = sol.u
        for i in output_indices
            append!(yss[i], map(u -> u[i], sol.u)[end-cutoff_step+1:end])
        end
    end

    # Create the figure
    fig = Figure()
    ax = Axis(fig[1, 1]; xlabel, ylabel)

    # Draw the fluctuations of output variables
    for (i, ys) in enumerate(yss)
        label = output_labels[output_indices[i]]
        scatter!(ax, xs, ys; markersize=markersize, label=label)
    end

    # Draw the baseline of parameter value
    ymin = minimum(minimum(ys) for ys in yss)
    ymax = maximum(maximum(ys) for ys in yss)
    lines!(
        [(param_base_value, ymin), (param_base_value, ymax)];
        color=baseline_color, linewidth=baseline_linewidth)

    resize_to_layout!(fig)
    axislegend(ax)

    return fig
end

"""
    $(SIGNATURES)

Plot the bifurcation diagram from `BifurcationData1d`.

### Options
$(BIFURCATION_DIAGRAM_1D_DOC)
"""
function plot_bifurcation_diagram_1d(
    data::BifurcationData1d{Params};
    output_indices::Vector=[1],
    output_labels::Vector=get_latex_name.(Params, output_indices),
    xlabel::String=get_latex_name(Params, first(data.change)),
    ylabel::String=get_ylabel(Params),
    cutoff_at_the_end::Real=0.2,
    baseline_color=:red,
    baseline_linewidth=1,
    markersize=3,
) where {Params<:AbstractEbmParams}
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
        u = sol.u
        for i in output_indices
            append!(yss[i], map(u -> u[i], sol.u)[end-cutoff_step+1:end])
        end
    end

    # Create the figure
    fig = Figure()
    ax = Axis(fig[1, 1]; xlabel, ylabel)

    # Draw the fluctuations of output variables
    for (i, ys) in enumerate(yss)
        label = output_labels[output_indices[i]]
        scatter!(ax, xs, ys; markersize=markersize, label=label)
    end

    # Draw the baseline of parameter value
    ymin = minimum(minimum(ys) for ys in yss)
    ymax = maximum(maximum(ys) for ys in yss)
    lines!(
        [
            (param_base_value, ymin),
            (param_base_value, ymax)
        ];
        color=baseline_color,
        linewidth=baseline_linewidth)

    resize_to_layout!(fig)
    axislegend(ax)

    return fig
end
