"""
get_efficiency(nPassed, nTotal)
Description of ```get_efficiency```
------------------------------
Returns efficiency as ```ε = Nₚ/Nₜₒₜ ```
"""
function get_efficiency(nPassed, nTotal = 1e5)
    return nPassed/nTotal
end
