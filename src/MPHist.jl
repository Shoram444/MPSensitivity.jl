
"""
	get_bin_content(inFile, h2dName, Emin, Emax)

Description of ```get_bin_content```
------------------------------
Provides bin content in the specified energy range.

Arguments:
	+ inFile 	- The ROOTFile of the 2d histogram
	+ h2dName 	- The name of the Th2F. Provided as string. (e.g. "h")
	+ Emin 		- Minimum energy of the deisred E range
	+ Emax      - Maximum energy of the deisred E range
-------------------------------
Example use:

We have TH2F file called "hist2D.root" opened in UnROOT as f = ROOTFile("hist2D.root"). The <NAME> of the histogram (generated in root as TH2F("<NAME>", "TITLE", ...)) is "h2".

To find bin content n at E ∈ (500, 600): n = ```get_bin_content(f, "h2", 500, 600)```.

FUNCTION ONLY WORKS IF THE HISTOGRAM IS SQUARE - meaning it has the same number of bins on x and y axes.
"""
function get_bin_content(inFile, h2dName, Emin, Emax)
	nbins = inFile[h2dName][:fXaxis_fNbins]
	binsize = inFile[h2dName][:fXaxis_fXmax] / nbins

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

	bincontent = inFile[h2dName][:fN][idx]
	return convert(Float64, bincontent)
end

"""
	MP_heatmap( xTicks::Vector{<:Real}, yTicks::Vector{<:Real}, data::Vector{<:Real}, stepSize = 100 )

Description of ```MP_heatmap```
------------------------------
Returns a Plots.heatmap object when provided 3 arrays x,y,z. Where x,y are the axes and z is the color of the cell. 

Arguments:
	+ xTicks 	- Vector x values associated with z values. Works with dataframe columns. Can be provided as eg. "df.EMins". 
	+ yTicks 	- Vector y values associated with z values. Works with dataframe columns. Can be provided as eg. "df.EMaxs". 
	+ data 		- Values for the z axis / color. Works with dataframe columns. Can be provided as eg. "df.NPassed". 
-------------------------------
Example use:
hm = MP_heatmap( df.EMins, df.EMaxs, df.NPassed)

"""
function MP_heatmap( xTicks::Vector{<:Real}, yTicks::Vector{<:Real}, data::Vector{<:Real}, stepSize = 100; kwargs... )
	dataMatrix = zeros( 
						length(unique(yTicks)), 
						length(unique(xTicks))
					  )

	x 	= unique(xTicks)
	y 	= unique(yTicks)

	for d in 1:length(data)
		if ( length(data) != length(xTicks) || length(data) != length(yTicks))
			error("Arrays must be the same size!")
		end

		r = convert(Int, yTicks[d]/stepSize + 1) # gives row index 
		c = convert(Int, xTicks[d]/stepSize + 1) # gives row index 

		dataMatrix[r,c] = data[d]
	end

	## checks if kwargs are provided
    if length(kwargs) == 0                ## if no kwargs are provided, use my default theme
        hm = Plots.heatmap(x,y,dataMatrix)

    else                                  ## if there are kwargs, they are unpacked using keys() 
        kwarg_names = keys(kwargs)        ## and iterated over to change the default dictionary <plot_args>
		
        for key in kwarg_names
            plot_args[key] = kwargs[key]
        end

        hm = Plots.heatmap(x,y,dataMatrix; plot_args...)
    end

	return hm
end


