using Revise
using CairoMakie

using Pkg
Pkg.activate(@__DIR__)

using EbmCommon
using EbmCommon.Examples
using EbmCommon.Api

const params = Examples.PredatorPreyParams()
Api.run_api(params; host="0.0.0.0")
