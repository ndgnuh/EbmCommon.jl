using EbmCommon
using EbmCommon.Examples
using CairoMakie


#= const params = Examples.PredatorPreyParams() =#
#= show(collect(params)) =#

#= let params = Examples.PredatorPreyParams() =#
#=     u0 = [1, 1] =#
#=     tspan = (0, 100.0) =#
#=     solution = EbmCommon.simulate(params, u0, tspan; dtmax=0.1) =#
#= end =#

#= let params = Examples.PredatorPreyParams() =#
#=     u0 = Float64[1, 1] =#
#=     tspan = (0, 100.0) =#
#=     data = EbmCommon.run_phase_portrait_2d( =#
#=         params, u0, =#
#=         1 => range(1, 5, 5), =#
#=         2 => range(1, 5, 5), =#
#=         tspan=(0, 100.0); =#
#=         solver_options=(dtmax=0.2,), =#
#=     ) =#
#=  =#
#=     fig = plot(data) =#
#=     save("test.pdf", fig) =#
#= end =#

# let params = Examples.PredatorPreyParams()
#     u0 = Float64[1, 1]
#     tspan = (0, 100.0)
#     data = EbmCommon.run_bifurcation_1d(
#         params, u0,
#         :δ => range(0, 2, 100),
#         solver_options=(dtmax=0.2,),
#     )
#     fig = plot(data)
# 
#     save("test.pdf", fig)
# end

#= let params = Examples.PredatorPreyParams() =#
#=     u0 = Float64[1, 1] =#
#=     tspan = (0, 100.0) =#
#=     data = EbmCommon.bifurcation_2d( =#
#=         params, =#
#=         :δ => range(0, 1, 900), =#
#=         :β => range(0, 1, 450), =#
#=     ) =#
#=     EbmCommon.set_makie_theme!() =#
#=     fig = plot(data) =#
#=  =#
#=     save("test.pdf", fig) =#
#= end =#

let params = Examples.PredatorPreyParams()
    EbmCommon.run_api(params)
end
