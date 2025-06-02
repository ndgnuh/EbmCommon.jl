@kwdef struct BifurcationData1d{Params<:AbstractEbmParams,T}
    base_params::Params
    u0::Vector
    change::Pair
    tspan::T
    params::Vector{Params}
    solutions::Vector{ODESolution}
    change_options = NamedTuple()
    solver_options = NamedTuple()
end

function run_bifurcation_1d(
    base_params::AbstractEbmParams,
    u0::AbstractVector,
    change::Pair;
    tspan=(0.0f0, 500.0f0),
    change_options=NamedTuple(),
    solver_options=(dtmax=0.2,),
)
    # Check for traits
    change_param = ParamsUpdater(base_params)

    # Data
    param_name, param_values = change
    params = map(param_values) do value
        change_param(base_params, param_name => value;
            change_options...)
    end
    solutions::Vector{ODESolution} = map(params) do params_
        _simulate(params_, u0, tspan; solver_options...)
    end

    return BifurcationData1d(;
        base_params,
        params,
        change,
        u0,
        tspan,
        solutions,
        change_options,
        solver_options,
    )
end
