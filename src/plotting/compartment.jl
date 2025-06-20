export plot_compartments

"""
$(TYPEDSIGNATURES)

Plot compartment simulation results using Makie.

# Parameters
#
- `data::SimulationResult{T}`: The simulation result containing the parameters and solution, where `T` is a subtype of `AbstractEbmParams`.
- `xlabel = get_xlabel(T)`: Label for the x-axis, defaults to the LaTeX name of the first parameter.
- `ylabel = get_ylabel(T)`: Label for the y-axis, defaults to the LaTeX name of the second parameter.
"""
function plot_compartments(
    data::SimulationResult{T};
    xlabel = get_xlabel(T),
    ylabel = get_ylabel(T),
) where {T <: AbstractEbmParams}
    fig = Figure()

    # Unpack the data
    params = data.params
    ax = Axis(fig[1, 1]; xlabel, ylabel)
    params = data.params
    solution = data.solution

    # Draw the compartments
    n = number_of_variables(params)
    t = solution.t
    for idx in 1:n
        x = map(u -> u[idx], solution.u)
        label = get_latex_name(params, idx)
        lines!(ax, t, x; label = label)
    end

    # Finish the plot
    axislegend(ax)
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
- `xlabel`: Label for the x-axis (default is obtained from `get_xlabel(T)`).
- `ylabel`: Label for the y-axis (default is obtained from `get_ylabel(T)`).
- `solver_options`: Additional options for the ODE solver (default is an empty `NamedTuple`).

See also: `plot_compartments`, `SimulationResult`, `simulate`, `number_of_variables`, `get_xlabel`, `get_ylabel`.
"""
function plot_compartments(
    params::T,
    u0::AbstractVector = ones(number_of_variables(T)),
    tspan = (0, 500.0);
    solver = Tsit5(),
    xlabel = get_xlabel(T),
    ylabel = get_ylabel(T),
    solver_options = NamedTuple(),
) where {T <: AbstractEbmParams}
    result = simulate(params, u0, tspan; solver, solver_options)
    return plot_compartments(result; xlabel, ylabel)
end
