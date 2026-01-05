module MyModule
using EbmCommon: @params, AbstractEbmParams
using Accessors

@enum Archetype::Bool begin
    FastTimeScale
    SlowTimeScale
end

display(
    @macroexpand(
        @params struct Model <: AbstractEbmParams
            x = 1
            z = x + y
            ε = 1.0e-3
            archetype::$(Archetype) = if ε == 0
                $(SlowTimeScale)
            else
                $(FastTimeScale)
            end
        end
    )
)

println("=============")

@params struct Model <: AbstractEbmParams
    x = 1

    z = x * 1.0
    ε = 1.0e-3
    archetype::$(Archetype) = if ε == 0
        $(SlowTimeScale)
    else
        $(FastTimeScale)
    end
end

m = Model()
println(m)

println("=============")

m2 = set(m, PropertyLens(:x), 10)
display(m2)

m3 = set(m, PropertyLens(:ε), 0)
display(m3)

end
