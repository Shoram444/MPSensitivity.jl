"""
get_best_ROI_index(r::Matrix{Float64})
Description of ```get_best_ROI_index```
------------------------------
Returns tuple of indeces of the best ROI as: ``` (id_row, id_col) ```

Arguments:
+ r   : array of rations S/B

see also get_best_ROI(r, Emins, Emaxs)
"""
function get_best_ROI_index(r::Matrix{Float64})
    return (argmax(r)[2], argmax(r)[1]) 
end


"""
get_best_ROI_index(r::Vector{Real})
Description of ```get_best_ROI_index```
------------------------------
Returns tuple of indeces of the best ROI as: ``` (id_row, id_col) ```

Arguments:
+ r   : array of rations S/B

see also get_best_ROI(r, Emins, Emaxs)
"""
function get_best_ROI_index(r::Vector{Real})
    return (argmax(r)) 
end


"""
get_best_ROI(r::Vector{Real}, Emins::Vector{Real}, Emaxs::Vector{Real})
Description of ```get_best_ROI_index```
------------------------------
Returns tuple of energies of the best ROI as: ``` (E_min, E_max) ```

Arguments:
+ r    : array of rations S/B
+ Emins: array of Energies E_min
+ Emaxs: array of Energies E_max

"""
function get_best_ROI(r::Vector{Real}, Emins::Vector{Real}, Emaxs::Vector{Real})
    return (Emins[argmax(r)], Emaxs[argmax(r)])
end



"""
get_best_ROI(r::Matrix{Float64}, Emins::Vector{Real}, Emaxs::Vector{Real})
Description of ```get_best_ROI_index```
------------------------------
Returns tuple of energies of the best ROI as: ``` (E_min, E_max) ```

Arguments:
+ r    : Tuple of rations S/B
+ Emins: array of Energies E_min
+ Emaxs: array of Energies E_max

"""
function get_best_ROI(r::Matrix{Float64}, Emins::Vector{Real}, Emaxs::Vector{Real})
    if (Emins[argmax(r)[1]] < Emaxs[argmax(r)[2]])
        return (Emins[argmax(r)[1]], Emaxs[argmax(r)[2]])
    else
        return (Emins[argmax(r)[2]], Emaxs[argmax(r)[1]])
    end
end