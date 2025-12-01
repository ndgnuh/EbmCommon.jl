"""
Grounded but not too grounded facility for
numerical experiment with EBMs.
"""
module EbmCommon

using Accessors
using RequiredInterfaces

using Reexport
using Base.Iterators: product
using OrdinaryDiffEqTsit5
using DocStringExtensions
using Chain: @chain
using StaticArrays
using UnPack
using Compat: @compat, @__FUNCTION__


@compat public get_routh_hurwiz_coefficients
export MVector, SVector
export AbstractEbmParams
export Bifurcation1d, PhasePortrait2d
export simulate, update, check_routh_hurwitz, get_jacobian

include("utilities.jl")
include("interface.jl")
include("numerical/simulate.jl")
include("numerical/bifurcation-1d.jl")
include("numerical/bifurcation-2d.jl")
include("numerical/phase-2d.jl")

include("Plotting/Plotting.jl")
@reexport using .Plotting

include("machine.jl")
using .MachineCalculated

# Lsp crash at public keyword, use @compat instead
# it should help with julia-1.10 and below too.
const machine = MachineCalculated
@compat public machine

# Ultilities for checking conditions, unit test, etc.
include("checks.jl")

end # module EbmCommon
