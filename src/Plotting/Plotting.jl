module Plotting

import EbmCommon as Ebm
using EbmCommon: options_for, construct_from_kwargs, get_compartment
using EbmCommon: get_xlabel, get_ylabel, get_latex_name

using EbmCommon: AbstractEbmParams
using EbmCommon: SimulationResult, simulate
using EbmCommon: PhasePortrait2d, run_phase_portrait_2d
using EbmCommon: Bifurcation1d, run_bifurcation_1d
using EbmCommon: Bifurcation2d, run_bifurcation_2d


using UnPack: @unpack
using DocStringExtensions
using Makie
using Makie.LaTeXStrings

include("compartment.jl")
include("phase_portrait.jl")
include("bifurcation_1d.jl")
include("stability_encoding.jl")
include("bifurcation_2d.jl")

export set_makie_theme!
export plot_compartments
export plot_phase_portrait
export plot_bifurcation_1d
export plot_stability_diagram

"""
$SIGNATURES

Set default theme for Makie.
"""
function set_makie_theme!(; fontsize = 14)
    theme = Theme(;
        figure_padding = 5,
        fontsize = fontsize,
        markersize = 7,
        CairoMakie = (
            antialias = :best,
            pt_per_unit = 2.0,
            px_per_unit = 2.0,
        ),
        Axis = (
            xticks = WilkinsonTicks(7; k_min = 5, k_max = 11),
            yticks = WilkinsonTicks(7; k_min = 5, k_max = 11),
            width = 600,
            height = 300,
            # aspect=21.0 / 9,
            pallete = Makie.wong_colors(),
        ),
        Axis3 = (
            xticks = WilkinsonTicks(7; k_min = 5, k_max = 11),
            yticks = WilkinsonTicks(7; k_min = 5, k_max = 11),
            width = 485,
            height = 300,
            pallete = Makie.wong_colors(),
        ),
        Lines = (linewidth = 2.5, linestyle = :solid),
    )

    theme = merge(theme, Makie.theme_latexfonts())
    set_theme!(theme)
    return theme
end


end
