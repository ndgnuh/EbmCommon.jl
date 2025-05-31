module Examples

import EbmCommon
import ..EbmCommon: AbstractEbmParams, EvolutionRule
using UnPack: @unpack

@kwdef struct PredatorPreyParams <: AbstractEbmParams
    K::Float64 = 2.0
    α::Float64 = 1.1
    β::Float64 = 0.4
    γ::Float64 = 0.1
    δ::Float64 = 0.4
end

function predator_prey_rule!(du, u, params::PredatorPreyParams, _)
    @unpack K, α, β, γ, δ = params
    x, y = u
    du[1] = α * x * (1 - x / K) - β * x * y
    du[2] = δ * x * y - γ * y
    nothing
end

function predator_prey_update(params::PredatorPreyParams, changes...)
    d = collect(params)
    for (k, v) in changes
        d[k] = v
    end
    return PredatorPreyParams(; d...)
end

EbmCommon.EvolutionRule(::PredatorPreyParams) = predator_prey_rule!
EbmCommon.ParamsUpdater(::PredatorPreyParams) = predator_prey_update
EbmCommon.number_of_variables(::PredatorPreyParams) = 2
EbmCommon.number_of_equilibria(::PredatorPreyParams) = 3

function EbmCommon.get_equilibria(params::PredatorPreyParams)
    @unpack α, β, γ, δ = params
    E0 = Float64[0, 0]
    E1 = Float64[K, 0]
    E2 = Float64[α/β, γ/δ]
    return [E0, E1, E2]
end

function EbmCommon.get_local_stabilities(params::PredatorPreyParams)
    @unpack γ, δ, β, K = params
    aux1 = γ / δ
    aux2 = 1 / β
    return [false, aux1 > K, aux1 < aux2]
end

end
