using EbmCommon
using EbmCommon.Examples
using EbmCommon: ModelSpecs, @ebmspecs
using EbmCommon.Api: run_api
using CairoMakie

#= display(@macroexpand @ebmspecs begin =#
#= 	time_axis_name = "time" =#
#= 	state_axis_name = "biomass" =#
#= 	variables = [ =#
#= 		x::Float64 = 0.9 description = "preys" latexname = "x"; =#
#= 		y::Float64 = 0.2 desc = "predators"; =#
#= 	] =#
#= 	parameters = PredatorPreyParams[ =#
#= 		α::Float64 = 1 description = "preys" latex = raw"\alpha"; =#
#= 		β::Float64 = 1 description = "predators" latexname = raw"\beta"; =#
#= 	] =#
#= end =#
#= ) =#



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

# let params = Examples.PredatorPreyParams()
#     run_api(params)
# end
