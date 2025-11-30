"""
This module contains function that automatically
calculate values using numerical methods.

Access this module using `using EbmCommon.MachineCalculated`
or using the `EbmCommon.machine` namespace.

The function in this module use the an Auto Diff package
and should have the same names as the functions in the
outer module.
"""
module MachineCalculated

using ReverseDiff
using DocStringExtensions
using LinearAlgebra
using Polynomials
using Compat: @compat

import ..EbmCommon as Ebm

@compat public jacobian, get_routh_hurwiz_coefficients

"""
$TYPEDSIGNATURES
Calculates and returns jacobian at a single state using forward diff.
"""
function jacobian(params::T, u::AbstractVector, t = 0.0) where {T <: Ebm.AbstractEbmParams}
    f!(du, x) = Ebm.evolve!(du, x, params, t)
    du = ones(length(u))
    return ReverseDiff.jacobian(f!, du, u)
end

"""
$TYPEDSIGNATURES
Calculate Routh-Hurwitz coefficients at a equilibrium.
The jacobian is calculated using forward diff.
"""
function get_routh_hurwiz_coefficients(
        params::T,
        E;
        exclude_roots = Set{Float64}(),
    ) where {T <: Ebm.AbstractEbmParams}
    J = jacobian(params, E)
    lambdas = eigvals(J)
    ignored = [any(isapprox(λ, ig) for ig in exclude_roots) for λ in lambdas]
    polys = [Polynomial([-λ, 1]) for (skip, λ) in zip(ignored, lambdas) if !skip]
    return coeffs(polys |> prod)
end

end
