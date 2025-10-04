using EbmCommon: @ebmspecs
using EbmCommon

@ebmspecs begin
	time_axis_name = "time"
	state_axis_name = "biomass"
	variables = [
		x::Float64 = 0.9 description = "preys" latexname = "x";
		y::Float64 = 0.2 desc = "predators";
	]
	parameters = PredatorPreyParams[
		α::Float64 = 1 description = "preys" latex = raw"\alpha";
		β::Float64 = 1 description = "predators" latexname = raw"\beta";
	]
end


params = PredatorPreyParams(α = 0.3)
EbmCommon.get_model_specifications(params)
