using UnROOT, Plots, LaTeXStrings
using MPSensitivity

# include("/home/shoram/Work/MPSensitivity/src/MPSensitivity.jl")
MPHist = MPSensitivity.MPHist

fTl = ROOTFile("/home/shoram/.julia/dev/MPSensitivity/test/Example/hist2DTl.root")
fBi = ROOTFile("/home/shoram/.julia/dev/MPSensitivity/test/Example/hist2DBi.root")

Emins = [e for e in 0:100:3500]
Emaxs = [e for e in 0:100:3500]
NpTl  = zeros(35,35)
NpBi  = zeros(35,35)
εTl   = zeros(35,35)
εBi   = zeros(35,35)
r     = zeros(35,35)

for min in 1:35
    for max in 1:35
        NpTl[max, min] = get_bin_content(fTl, "h2", Emins[min], Emaxs[max])
        NpBi[max, min] = get_bin_content(fBi, "h2", Emins[min], Emaxs[max])
        εTl[max, min]  = get_efficiency(NpTl[max, min], 1e5)
        εBi[max, min]  = get_efficiency(NpBi[max, min], 1e5)
        r[max, min]    = get_SB_ratio( (1, εBi[max, min]) , (1, εTl[max, min]) )
    end
end

l = @layout [[a b ; c d] ;e{0.6h} ]

##
hmPTl       = heatmap(Emins, Emaxs, NpTl, title ="N_passed Tl", xlabel = "E_min", ylabel = "E_max",
                c= :thermal, xlims=(0,3500), ylims = (0, 3500), size=(1000,1000))
hmPBi       = heatmap(Emins, Emaxs, NpBi, title ="N_passed Bi", xlabel = "E_min", ylabel = "E_max",
                c= :thermal, xlims=(0,3500), ylims = (0, 3500), size=(1000,1000))
hmEffTl     = heatmap(Emins, Emaxs, εTl, title ="εTl", xlabel = "E_min", ylabel = "E_max",
                c= :thermal, xlims=(0,3500), ylims = (0, 3500), size=(1000,1000))
hmEffBi     = heatmap(Emins, Emaxs, εBi, title ="εBi", xlabel = "E_min", ylabel = "E_max",
                c= :thermal, xlims=(0,3500), ylims = (0, 3500), size=(1000,1000))
hmRatios    = heatmap(Emins, Emaxs, r, title =L"S/B \equiv \varepsilon_{Bi}A_{Bi}/ \varepsilon_{Tl}A_{Tl}", xlabel = "E_min", ylabel = "E_max",
                c= :thermal, xlims=(0,3500), ylims = (0, 3500), size=(1000,1000))
##
p = plot(hmPTl, hmEffTl, hmPBi, hmEffBi, hmRatios, layout = l, dpi = 800,
            right_margin = 4Plots.mm, left_margin = 4Plots.mm)
savefig(p, "fig.png")


E_min = get_best_ROI(r, Emins, Emaxs)[1]
E_max = get_best_ROI(r, Emins, Emaxs)[2]

