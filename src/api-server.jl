module Api

using Oxygen
using Makie
using EbmCommon
using UnPack
using HTTP

using ..EbmCommon: run_phase_portrait_2d
using ..EbmCommon: run_bifurcation_1d
using ..EbmCommon: run_bifurcation_2d
using ..EbmCommon: simulate
using ..EbmCommon: AbstractEbmParams, ParamsUpdater
using ..EbmCommon: get_model_specifications


const experiment_router = Oxygen.router(
    "/experiment", tags=["experiments"])
const model_router = Oxygen.router(
    "/model", tags=["model"])

struct InitialConditionVariation
    index::Int
    min::Float64
    max::Float64
    n::Int
end

struct ParameterVariation
    name::Symbol
    min::Float64
    max::Float64
    n::Int
end

@kwdef struct SimulationRequest
    parameters::Dict{Symbol,Float64}
    u0::Vector{Float64}
    tmax::Float64
    dtmax::Float64
end

@kwdef struct PhaseDataRequest
    parameters::Dict{Symbol,Float64}
    u0::Vector{Float64}
    xchange::InitialConditionVariation
    ychange::InitialConditionVariation
    tmax::Float64
    dtmax::Float64
end

struct Bifurcation1dRequest
    parameters::Dict{Symbol,Float64}
    update::ParameterVariation
    u0::Vector{Float64}
    tmax::Float64
    dtmax::Float64
end

struct Bifurcation2dRequest
    parameters::Dict{Symbol,Float64}
    x_update::ParameterVariation
    y_update::ParameterVariation
end

function figure_to_bytes(fig::Figure)
    io = IOBuffer()
    show(io, MIME"image/png"(), fig)
    seekstart(io)
    return read(io)
end

function response_buffer(fig::Figure)
    return response_buffer(figure_to_bytes(fig))
end

function response_buffer(data::Vector{UInt8})
    headers = [
        "Content-Type" => "image/png",
        "Content-Disposition" => "inline; filename='figure.png'"
    ]
    return Response(200, headers, data)
end

function run_api(base_params::AbstractEbmParams)
    # Bootstrap
    EbmCommon.set_makie_theme!()
    update_params = ParamsUpdater(base_params)
    get_model_specifications(base_params)
    update_params(base_params)

    @get model_router("/specifications") function (::Request)
        specs = get_model_specifications(base_params)
        return Oxygen.json(specs)
    end

    @post experiment_router("/simulate") function (
        ::Request, params::Json{SimulationRequest}
    )
        data = params.payload
        u0 = data.u0
        solver_options = (dtmax=data.dtmax,)
        tmax = something(data.tmax, 500.0)
        params = update_params(base_params, data.parameters...)

        # Simulate
        sol = simulate(params, u0, (0.0, tmax); solver_options...)
        fig, ax, p = plot(sol)
        axislegend(ax)
        resize_to_layout!(fig)

        return response_buffer(fig)
    end

    function _convert_variation(change::ParameterVariation)
        @unpack name, min, max, n = change
        return name => range(min, max, n)
    end
    function _convert_variation(change::InitialConditionVariation)
        @unpack index, min, max, n = change
        return index => range(min, max, n)
    end

    @post experiment_router("/phase-portrait") function (
        ::Request, params::Json{PhaseDataRequest}
    )
        data = params.payload
        @unpack parameters, u0, xchange, ychange, tmax = data

        # Convert request to inputs
        tspan = (0.0, something(tmax, 500.0))
        _xchange = _convert_variation(xchange)
        _ychange = _convert_variation(ychange)
        solver_options = (dtmax=data.dtmax,)

        # Do experiment
        params = update_params(base_params, parameters...)
        data = run_phase_portrait_2d(
            params, u0, _xchange, _ychange;
            tspan, solver_options)
        fig, ax, _ = plot(data)
        resize_to_layout!(fig)

        return response_buffer(fig)
    end

    @post experiment_router("/bifurcation-1d") function (
        ::Request, params::Json{Bifurcation1dRequest}
    )
        data = params.payload
        @unpack parameters, u0, tmax = data

        # Convert request to inputs
        tspan = (0.0, something(tmax, 500.0))
        update = _convert_variation(data.update)
        solver_options = (dtmax=data.dtmax,)

        # Do experiment
        paramname = data.update.name
        params = update_params(base_params, parameters...)
        output = run_bifurcation_1d(
            params, u0, update;
            tspan, solver_options)


        specs = EbmCommon.get_parameter_specifications(params)
        description = specs[paramname].description

        fig = Figure()
        ax = Axis(
            fig[1, 1],
            xlabel=description,
            ylabel="Population",
        )
        plot!(ax, output)
        resize_to_layout!(fig)

        return response_buffer(fig)
    end

    @post experiment_router("/bifurcation-2d") function (
        ::Request, request_params::Json{Bifurcation2dRequest}
    )
        # Unpack
        data = request_params.payload
        params = update_params(base_params, collect(data.parameters)...)
        xupdate = _convert_variation(data.x_update)
        yupdate = _convert_variation(data.y_update)

        # Run experiment and plot
        output_data = run_bifurcation_2d(params, xupdate, yupdate)
        fig, _, _ = plot(output_data)
        return response_buffer(fig)
    end

    serve()
end

end
