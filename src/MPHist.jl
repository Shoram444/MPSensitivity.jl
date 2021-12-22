
"""
	get_bin_content(h2d, h2dName, Emin, Emax)

Description of ```get_bin_content```
------------------------------
Provides bin content in the specified energy range.

Arguments:
	+ h2d 		- The ROOTFile of the 2d histogram
	+ h2dName 	- The name of the Th2F. Provided as string. (e.g. "h")
	+ Emin 		- Minimum energy of the deisred E range
	+ Emax      - Maximum energy of the deisred E range
-------------------------------
Example use:

We have TH2F file called "hist2D.root" opened in UnROOT as f = ROOTFile("hist2D.root"). The <NAME> of the histogram (generated in root as TH2F("<NAME>", "TITLE", ...)) is "h2".

To find bin content n at E ∈ (500, 600): n = ```get_bin_content(f, "h2", 500, 600)```.

FUNCTION ONLY WORKS IF THE HISTOGRAM IS SQUARE - meaning it has the same number of bins on x and y axes.
"""
function get_bin_content(h2d, h2dName, Emin, Emax)
	nbins = h2d[h2dName][:fXaxis_fNbins]
	binsize = h2d[h2dName][:fXaxis_fXmax] / nbins

	row = floor(Emax/binsize) - 1
	col = floor(Emin/binsize) + 1

	#=
	To get the index from the array :fN the algorithm is as follows.
	First 3 bins are 0 (for some unknown reason, that's how root is written)
	The next <nbins> number of the array are also zero - these correspond to all the underwflow xbins
	Afterwards <nbins> number of bins correspond to the first row in the histogram.
	2 bins are empty again - these are overflow bins for x and y (in one row).
	=#
	idx = convert(Int64, 3 + nbins + (nbins+2)*row + col)

	bincontent = h2d[h2dName][:fN][idx]
	return convert(Float64, bincontent)
end

