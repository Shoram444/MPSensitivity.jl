"""
get_best_ROI_index(r)
Description of ```get_best_ROI_index```
------------------------------
Returns tuple of indeces of the best ROI as: ``` (id_row, id_col) ```

Arguments:
+ r   : array of rations S/B

see also get_best_ROI(r, Emins, Emaxs)
"""
function get_best_ROI_index(r)
    return (argmax(r)[2], argmax(r)[1]) 
end



"""
get_best_ROI(r, Emins, Emaxs)
Description of ```get_best_ROI_index```
------------------------------
Returns tuple of energies of the best ROI as: ``` (E_min, E_max) ```

Arguments:
+ r    : array of rations S/B
+ Emins: array of Energies E_min
+ Emaxs: array of Energies E_max

see also get_best_ROI(r, Emins, Emaxs)
"""
function get_best_ROI(r, Emins, Emaxs)
    if (Emins[argmax(r)[1]] < Emaxs[argmax(r)[2]])
        return (Emins[argmax(r)[1]], Emaxs[argmax(r)[2]])
    else
        return (Emins[argmax(r)[2]], Emaxs[argmax(r)[1]])
    end
end