export Bifurcation2d, Bifurcation2dConfig, run_bifurcation_2d

"""
$TYPEDFIELDS

Input for 2d theoretical bifurcation map.
"""
@kwdef struct Bifurcation2dConfig{T, T1, T2}
    "Base parameters"
    params::T
    "First parameter update specifications"
    x_updates::Pair{Symbol, T1}
    "Second parameter update specifications"
    y_updates::Pair{Symbol, T2}
    "Extra update callbacks"
    update_callback = nothing
end

"""
$TYPEDFIELDS

Output when running 2d-bifurcation map.
"""
@kwdef struct Bifurcation2d{T, T1, T2}
    config::Bifurcation2dConfig{T, T1, T2}
    stabilities::Matrix{BitVector}
end

"""
$TYPEDSIGNATURES

Change 2 parameters and check the theoretical stabilities.
"""
function run_bifurcation_2d(
        config::Bifurcation2dConfig
    )::Bifurcation2d
    @unpack params, x_updates, y_updates, update_callback = config
    x_name, x_values = x_updates
    y_name, y_values = y_updates
    iter = product(x_values, y_values)
    stabilities = map(iter) do (x, y)
        updated = update(
            params, x_name => x, y_name => y;
            update_callback
        )
        s = get_local_stabilities(updated)
        return BitVector(s)
    end

    return Bifurcation2d(; config, stabilities)
end

"""
$SIGNATURES

Options: $(options_for(Bifurcation2dConfig))
"""
function run_bifurcation_2d(params; options...)::Bifurcation2d
    config = construct_from_kwargs(
        Bifurcation2dConfig;
        params = params,
        options...
    )
    output = run_bifurcation_2d(config)
    return output
end
