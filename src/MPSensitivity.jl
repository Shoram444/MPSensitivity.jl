module MPSensitivity

using UnROOT, Plots

include("MPHist.jl")
export get_bin_content
export MP_heatmap

include("MPEfficiency.jl")
export get_efficiency

include("MPStoB.jl")
export get_SB_ratio

include("MPROI.jl")
export get_best_ROI_index
export get_best_ROI

end # module MPSensitivity