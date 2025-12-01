module example

using StaticArrays
using EbmCommon
using UnPack

import EbmCommon as Ebm

export LkModel

"""
Lotka-Volterra model with carrying capacity
"""
@kwdef struct LkModel <: AbstractEbmParams
    K::Float64 = 200
    α::Float64 = 0.3
    β::Float64 = 0.024
    γ::Float64 = 0.052
    δ::Float64 = 0.003
end

# Numerical solving interfaces
# ============================

Ebm.default_u0(::LkModel) = MVector(37.0, 14.0)
Ebm.default_tspan(::LkModel) = (0.0, 400.0)
Ebm.default_solver_options(::LkModel) = (; dtmax = 0.2)

function Ebm.evolve!(du::AbstractVector, u::AbstractVector, model::LkModel, ::Real)::Nothing
    @unpack K, α, β, γ, δ = model

    n, p = u
    du[1] = α * n * (1 - n / K) - β * n * p
    du[2] = δ * n * p - γ * p
    return nothing
end

function Ebm.evolve(u::AbstractVector, model::LkModel, ::Real)::MVector
    @unpack K, α, β, γ, δ = model

    n, p = u
    du1 = α * n * (1 - n / K) - β * n * p
    du2 = δ * n * p - γ * p
    return MVector(du1, du2)
end

# Specifications related interfaces
# =================================

Ebm.get_xlabel(::LkModel) = "Time"
Ebm.get_ylabel(::LkModel) = "Population density"

Ebm.get_latex_name(::LkModel, name::Symbol) = Dict(
    :α => raw"$\alpha$",
    :β => raw"$\beta$",
    :γ => raw"$\gamma$",
    :δ => raw"$\delta$",
    :K => raw"$K$",
)[name]

Ebm.get_latex_name(::LkModel, name::Integer) = Dict(
    1 => raw"$N$",
    2 => raw"$P$"
)[name]

Ebm.get_latex_name(::LkModel, name::Tuple) = throw(
    ArgumentError("Tuple indexing not supported for LkModel")
)

# Calculations interfaces
# =======================

function Ebm.get_equilibria(params::LkModel)
    @unpack K, α, β, γ, δ = params

    eq1 = SVector(0.0, 0.0)
    eq2 = SVector(K, 0.0)
    eq3 = let
        n = γ / δ
        p = (α / β) * (1 - γ / K / δ)
        SVector(n, p)
    end
    return [eq1, eq2, eq3]
end

function Ebm.get_local_stabilities(params::LkModel)
    @unpack K, α, β, γ, δ = params
    s1 = false
    s2 = δ * K - γ < 0
    s3 = (1 - γ / K / δ) > 0
    stabilities = SVector(s1, s2, s3)
    return stabilities
end


function Ebm.get_jacobian(params::LkModel, u::AbstractVector)
    @unpack K, α, β, γ, δ = params

    x, y = u
    J = zeros(2, 2)
    J11 = 1 + α * (1 - 2 * x) - β
    J12 = -β
    J21 = -δ
    J22 = 1 + γ * (1 - 2 * y)

    return SMatrix(
        [
            J11 J12;
            J21 J22;
        ]
    )
end

end # module example
