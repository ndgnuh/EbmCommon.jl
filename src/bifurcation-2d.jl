export Bifurcation2d, run_bifurcation_2d

"""
Context for encoding stability. This also checks for total number
of equilibrium beforehand, so a silent bug wont happen.
"""
struct StabilityEncoder{T <: Unsigned}
    num_equilibria::Int
    function StabilityEncoder(::Type{T}, num_equilibria::Int) where {T <: Unsigned}
        max_equilibiria = if T == UInt8
            8
        elseif T == UInt16
            16
        elseif T == UInt32
            32
        elseif T == UInt64
            64
        elseif T == UInt128
            128
        end
        @assert num_equilibria <= max_equilibiria
        return new{T}(num_equilibria)
    end
    function StabilityEncoder(p::AbstractEbmParams)
        n_equilibria = number_of_equilibria(p)
        ns = [8, 16, 32, 64, 128]
        Ts = [UInt8, UInt16, UInt32, UInt64, UInt128]
        for (n, T) in zip(ns, Ts)
            if n >= n_equilibria
                return new{T}(n)
            end
        end
        @assert false "Model has too many equilibria"
    end
    StabilityEncoder(n::Int) = StabilityEncoder(UInt8, n)
end

"""
$(TYPEDSIGNATURES)

Encode a boolean stabilty vector to an unsigned int.
"""
function encode_stability(
    ::StabilityEncoder{E},
    stability::AbstractVector{T},
) where {E <: Unsigned, T <: Bool}
    base_flag = one(E)
    flag = zero(E)
    for stable in stability
        stable && (flag |= base_flag)
        base_flag <<= 1
    end
    return flag
end

"""
Returns a LaTeX string with the names of the equilibria depending on the stability flag.

# Parameters

  - `se::StabilityEncoder{T}`: Stability encoder that contains the number of equilibria.
  - `flag::T`: Stability flag, an unsigned integer where each bit represents the stability of an equilibrium.
"""
function stability_flagname(se::StabilityEncoder{T}, flag::T) where {T <: Unsigned}
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

"""
$(TYPEDSIGNATURES)

Decode stability array from flag and return a boolean vector.
The total number of stability is required so that the vector's length is fixed.
"""
function decode_stability(se::StabilityEncoder{T}, flag::T)::BitVector where {T <: Unsigned}
    n = se.num_equilibria
    base_flag = one(T)
    stablities = BitVector(Iterators.take(Iterators.repeated(false), n))
    for i in 1:n
        stablities[i] = (base_flag & flag) > 0
        base_flag <<= 1
    end
    stablities
end

"""
The `Bifurcation2d` struct holds the results of a 2D bifurcation analysis.

$(TYPEDFIELDS)
"""
@kwdef struct Bifurcation2d{P <: AbstractEbmParams}
    "First parameter's values after varying"
    xvalues::Vector
    "First parameter's values after varying"
    yvalues::Vector
    "Map of stability flags for each combination of x and y values"
    stability_map::Matrix
    "Base parameters used for the simulation"
    base_params::P
    """
    Pair of `name::Sybmol => values` correspond to
    changes in the first parameter
    """
    update_x::Pair
    """
    Pair of `name::Sybmol => values` correspond to
    changes in the second parameter
    """
    update_y::Pair
    """
    Options for updating parameters.
    This is a `NamedTuple` that can contain any options
    that are passed to `ParamsUpdater`.
    """
    update_options = NamedTuple()
end

"""
$(TYPEDSIGNATURES)

Varies 2 parameters of the model and check the local stability
of the system at each point in the parameter space.

This is not actually a bifurcation analysis, because it does not
run the simulation, but rather checks the local stability theoretically.

# Parameters

  - `base_params::AbstractEbmParams`: The base parameters used for the simulation.
  - `update_x::Pair`: A pair of (`xname`, `xvalues`) that specify the first parameter to be varied.
  - `update_y::Pair`: A pair of (`yname`, `yvalues`) that specify the second parameter to be varied.
  - `update_options = NamedTuple()`: Options for updating parameters.
    This is a `NamedTuple` that can contain any options
    that are passed to `ParamsUpdater`.

The model parameters of type `P` must implement the `ParamsUpdater(::Type{P})` and `get_local_stabilities(::P)` methods for this function to work.
"""
function run_bifurcation_2d(
    base_params,
    update_x::Pair{Symbol, T1},
    update_y::Pair{Symbol, T2},
    update_options = NamedTuple(),
) where {T1, T2}
    # Prepare and unpack the parameters
    sec = StabilityEncoder(base_params)
    xname, xvalues = update_x
    yname, yvalues = update_y

    iter = Iterators.product(xvalues, yvalues)
    stability_map = map(iter) do (xvalue, yvalue)
        params = update_params(base_params, xname => xvalue, yname => yvalue; update_options...)
        stabilities = get_local_stabilities(params)
        return encode_stability(sec, stabilities)
    end

    return Bifurcation2d(;
        xvalues = xvalues |> collect,
        yvalues = yvalues |> collect,
        stability_map,
        base_params,
        update_x,
        update_y,
        update_options,
    )
end
