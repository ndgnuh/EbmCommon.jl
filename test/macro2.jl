import EbmCommon: @params, AbstractEbmParams

function f(; x, K1, K2, _...)
    return (K1 + K2) * x
end

@params struct Model <: AbstractEbmParams
    K1 = 55.0
    K2 = 40.0
    r1 = 0.95
    r2 = 0.8
    a1 = 0.4
    a2 = 0.7
    d1J = 0.003
    d2J = 0.001
    d1A = 0.03
    d2A = 0.01
    γ1 = 0.05
    γ2 = 0.04
    η1 = 0.03
    η2 = 0.06
    h1A = 0.1
    h2A = 0.1
    h1J = 0.05
    h2J = 0.05
    ε = 0.1
    m0 = 1.0
    m1 = 0.03
    m2 = 0.7
    m11 = 0.1
    m12 = 0.3
    m01 = 15.0
    m02 = 6.0

    # Do not pass these parameters when constructing the model.
    # They won't change anything. Too lazy to hack into ConstructionBase
    # to make them truly derived parameters (cannot passed in to constructor).
    # At lease you cannot pass them in the keyword arguments constructor

    # Derived parameters
    @hide δ1J = d1J + h1J + γ1
    @hide δ2J = d2J + h2J + γ2
    @hide δ1A = d1A + h1A
    @hide δ2A = d2A + h2A

    K_total = $f(; x = 100, @everything)

    @hide μ1 = m1 / (m1 + m2)
    @hide μ2 = m2 / (m1 + m2)
    @hide ρ1 = (m11 * μ1 + m12 * μ2) * m0
    @hide ρ0 = (m01 + m02) * m0
    @hide α1 = a1 * μ1 * m01 * m0
    @hide α2 = a2 * μ2 * m02 * m0
    @hide β1 = a1 * μ1^2 * m11 * m0
    @hide β2 = a2 * μ2^2 * m12 * m0
    @hide ψ1 = δ1A * m11 * μ1 + δ2A * m12 * μ2
    @hide ψ0 = δ1A * m01 + δ2A * m02
    @hide r = r1 * μ1 + r2 * μ2
    @hide K = (r * K1 * K2) / (r1 * μ1^2 * K1 + r2 * μ2^2 * K2)

    @hide α = α1 + α2
    @hide β = β1 + β2

    #= archetype::$(ModelArchetype) = if m0 == m1 == m2 == 0 =#
    #=     $(IsolatedModel) =#
    #= elseif ε == 0 =#
    #=     $(AggregatedModel) =#
    #= else =#
    #=     $(FullModel) =#
    #= end =#
end

m = Model()
println(m)
