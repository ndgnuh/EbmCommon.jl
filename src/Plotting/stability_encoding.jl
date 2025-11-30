# Module for encoding and decoding
# stability information of equilibria in a dynamical system.
"""
$(TYPEDFIELDS)

Context for encoding stability.

This also checks for total number of equilibrium beforehand, so a silent bug wont happen.
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
    function StabilityEncoder(::P) where {P <: AbstractEbmParams}
        n_equilibria = number_of_equilibria(P)
        ns = [8, 16, 32, 64, 128]
        Ts = [UInt8, UInt16, UInt32, UInt64, UInt128]
        for (n, T) in zip(ns, Ts)
            if n >= n_equilibria
                return new{T}(n)
            end
        end
        return @assert false "Model has too many equilibria"
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
    return stablities
end
