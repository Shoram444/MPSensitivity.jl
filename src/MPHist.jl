
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
	`MP_heatmap( xTicks::Vector{<:Real}, yTicks::Vector{<:Real}, data::Vector{<:Real}, stepSize = 100 )``

Description of `MP_heatmap`
------------------------------
Returns a Plots.heatmap object when provided 3 arrays x,y,z. Where x,y are the axes and z is the color of the cell. 

Arguments:

	xTicks 	- Vector x values associated with z values. Works with dataframe columns. Can be provided as eg. "df.EMins". 
	yTicks 	- Vector y values associated with z values. Works with dataframe columns. Can be provided as eg. "df.EMaxs". 
	data 		- Values for the z axis / color. Works with dataframe columns. Can be provided as eg. "df.NPassed". 

-------------------------------
Example use:
hm = MP_heatmap( df.EMins, df.EMaxs, df.NPassed)

"""
function MP_heatmap( xTicks::Vector{<:Real}, yTicks::Vector{<:Real}, data::Vector{<:Real}, stepSize = 100; kwargs... )
    dataMatrix = zeros( 
                        length(unique(yTicks)), 
                        length(unique(xTicks))
                        )
    if ( unique(xTicks)[1] <= 0 )
        x  = unique(xTicks) .+ stepSize/2   # x specifies the midpoints of the bins 
    else
        x  = unique(xTicks) .- stepSize/2   # x specifies the midpoints of the bins 
    end
    
    if ( unique(yTicks)[1] <= 0 )
        y  = unique(yTicks) .+ stepSize/2   # y specifies the midpoints of the bins 
    else
        y  = unique(yTicks) .- stepSize/2   # y specifies the midpoints of the bins 
    end
    
    for d in 1:length(data)  # each data point is mapped onto the matrix, where row and col are specified
        if ( length(data) != length(xTicks) || length(data) != length(yTicks))
            error("Arrays must be the same size!")
        end
        
        if (yTicks[1] <= 0) # since Julia indexing starts from 1, we must add 1 if row was to be 0
            r = convert(Int, yTicks[d]/stepSize + 1) # gives row index 
        else
            r = convert(Int, yTicks[d]/stepSize ) # gives row index 
        end
        
        if (xTicks[1] <= 0) # since Julia indexing starts from 1, we must add 1 if col was to be 0
            c = convert(Int, xTicks[d]/stepSize + 1) # gives row index 
        else
            c = convert(Int, xTicks[d]/stepSize ) # gives row index 
        end
        
        dataMatrix[r,c] = data[d]
    end
    dataMatrix = replace!(dataMatrix, 0.0 => NaN)

    hm = Plots.heatmap(x,y,dataMatrix; kwargs...)

    return hm
end


