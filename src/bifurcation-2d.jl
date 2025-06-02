"""
Context for encoding stability. This also checks for total number
of equilibrium beforehand, so a silent bug wont happen.
"""
struct StabilityEncoder{T<:Unsigned}
    num_equilibria::Int
    function StabilityEncoder(
        ::Type{T}, num_equilibria::Int
    ) where {T<:Unsigned}
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
Encode a boolean stabilty vector to an unsigned int.
"""
function encode_stability(
    ::StabilityEncoder{E}, stability::AbstractVector{T}
) where {E<:Unsigned,T<:Bool}
    base_flag = one(E)
    flag = zero(E)
    for stable in stability
        stable && (flag |= base_flag)
        base_flag <<= 1
    end
    return flag
end

function stability_flagname(se::StabilityEncoder{T}, flag::T) where {T<:Unsigned}
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
Decode stability array from flag and return a boolean vector.
The total number of stability is required so that the vector's length is fixed.
"""
function decode_stability(
    se::StabilityEncoder{T}, flag::T
)::BitVector where {T<:Unsigned}
    n = se.num_equilibria
    base_flag = one(T)
    stablities = BitVector(Iterators.take(Iterators.repeated(false), n))
    for i in 1:n
        stablities[i] = (base_flag & flag) > 0
        base_flag <<= 1
    end
    stablities
end

@kwdef struct BifurcationData2d{P<:AbstractEbmParams}
    # Results
    xvalues::Vector
    yvalues::Vector
    stability_map::Matrix
    # Inputs
    base_params::P
    update_x::Pair
    update_y::Pair
    update_options = NamedTuple()
end

"""
Create data for 2d bifurcation diagram
"""
function run_bifurcation_2d(
    base_params::AbstractEbmParams,
    update_x::Pair,
    update_y::Pair;
    update_options=NamedTuple(),
)
    sec = StabilityEncoder(base_params)

    xname, xvalues = update_x
    yname, yvalues = update_y

    update = ParamsUpdater(base_params)
    stability_map = map(Iterators.product(xvalues, yvalues)) do (x, y)
        params = update(
            base_params, xname => x, yname => y;
            update_options...)
        stabilities = get_local_stabilities(params)
        return encode_stability(sec, stabilities)
    end

    return BifurcationData2d(;
        xvalues=xvalues |> collect,
        yvalues=yvalues |> collect,
        stability_map,
        base_params,
        update_x,
        update_y,
        update_options,
    )
end

