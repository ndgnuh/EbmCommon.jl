import EbmCommon as Ebm

using Makie

using EbmCommon
using Test
using example: LkModel
using RequiredInterfaces
const RI = RequiredInterfaces

let (ok, faults) = Ebm.check_implementation(LkModel)
    @test ok
end

@testset "Simulation API" begin
    model = LkModel()
    display(model)

    model = Ebm.update(model, :K => 100.0)
    display(model)

    model = Ebm.update(model, :K => 120.0)
    display(model)

    Ebm.simulate(; params = model)
    @test true

    Ebm.run_bifurcation_1d(
        model;
        param_updates = :γ => range(0.0001, 10, 100)
    )
    @test true

    Ebm.run_phase_portrait_2d(
        model;
        x_updates = 1 => range(0.1, 10, 8),
        y_updates = 1 => range(0.1, 10, 8),
    )
    @test true

    Ebm.run_bifurcation_2d(
        model;
        x_updates = :β => range(0.01, 1, 100),
        y_updates = :α => range(0.01, 1, 100),
    )
    @test true
end

#= @testset "Plotting" begin =#
#=     model = LkModel() =#
#=     Ebm.set_makie_theme!() =#
#=  =#
#=     result = Ebm.simulate(; params = model) =#
#=     Ebm.plot_compartments(result; output_indices = 1) =#
#=     Ebm.plot_compartments(model; u0 = [1.0, 2.0], output_indices = 2) =#
#=     @test true =#
#=  =#
#=     result = Ebm.run_phase_portrait_2d(; params = model) =#
#=     Ebm.plot_phase_portrait(result; output_indices = 1) =#
#=     Ebm.plot_phase_portrait(model; u0 = [1.0, 2.0], output_indices = 2) =#
#=     @test true =#
#= end =#
