export plot_compartments

"""
$(TYPEDSIGNATURES)

Plot compartment simulation results using Makie.

# Parameters
#
- `data::SimulationResult{T}`: The simulation result containing the parameters and solution, where `T` is a subtype of `AbstractEbmParams`.
- `xlabel = get_xlabel(T)`: Label for the x-axis, defaults to the LaTeX name of the first parameter.
- `ylabel = get_ylabel(T)`: Label for the y-axis, defaults to the LaTeX name of the second parameter.
- `output_indices = 1:number_of_variables(T)`: Indices of the compartments to plot, defaults to all compartments.
- `linestyle = :solid`: Line style for the plot.
- `colormap = Makie.wong_colors()`: Colormap for the plot.
- `legend_position = (:right, :top)`: Position of the legend in the plot.
- `labels = get_latex_name.(T, output_indices)`: Labels for the compartments, defaults to the LaTeX names of the compartments.
- `fig = Figure()`: The figure to draw on, defaults to a new `Figure`.
- `ax = Axis(fig[1, 1]; xlabel, ylabel)`: The axis to draw on, defaults to a new `Axis` with the specified labels.
"""
function plot_compartments(
    data::SimulationResult{T};
    xlabel = get_xlabel(T),
    ylabel = get_ylabel(T),
    output_indices = 1:number_of_variables(T),
    linestyle = :solid,
    colormap = Makie.wong_colors(),
    legend_position = (:right, :top),
    labels = get_latex_name.(T, output_indices),
    fig = Figure(),
    ax = Axis(fig[1, 1]; xlabel, ylabel),
) where {T <: AbstractEbmParams}

    # Unpack the data
    solution = data.solution

    # Draw the compartments
    t = solution.t
    for (idx, label) in zip(output_indices, labels)
        x = get_compartment(solution.u, idx)
        lines!(ax, t, x; label, linestyle, colormap = colormap)
    end

    # Finish the plot
    axislegend(ax; position = legend_position)
    resize_to_layout!(fig)

    return fig
end

# awrapper functio for `plot_compartments`
# that accepts the parameters and use `simulate` to obtain `SimulationResult`
"""
$(TYPEDSIGNATURES)

Plot compartments of the model using the given parameters and initial conditions. Returns a `Figure`.

This function uses the `simulate` function to obtain `SimulationResult` and then calls `plot_compartments` to create the plot..

# Arguments:
- `params::T`: The parameters of the model, where `T` is a subtype of `AbstractEbmParams`.
- `u0::AbstractVector`: Initial conditions for the simulation (default is a vector of ones). For the default to work, `number_of_variables(T)` must be implemented.
- `tspan::Tuple`: Time span for the simulation (default is `(0, 500.0)`).

# Optional keyword arguments:
- `solver`: The ODE solver to use (default is `Tsit5()`).
- `solver_options`: Additional options for the ODE solver (default is an empty `NamedTuple`).
- `kwargs...`: Additional keyword arguments passed to `plot_compartments`.

See also: `plot_compartments`, `SimulationResult`, `simulate`, `number_of_variables`, `get_xlabel`, `get_ylabel`.
"""
function plot_compartments(
    params::T,
    u0::AbstractVector = ones(number_of_variables(T)),
    tspan = (0, 500.0);
    solver = get_default_solver(T),
    solver_options = get_default_solver_options(T),
    kwargs...,
) where {T <: AbstractEbmParams}
    result = simulate(params, u0, tspan; solver, solver_options)
    return plot_compartments(result; kwargs...)
end
