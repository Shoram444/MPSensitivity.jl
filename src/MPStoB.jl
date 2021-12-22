"""
	get_SB_ratio( sig, b1 )
Description of ```get_SB_ratio```
------------------------------
Returns signal-to-background ratio defined as: ```r = A₁ε₁ / A₂ε₂ ```

See also get_SB_ratio( sig, b1, b2 ).
"""
function get_SB_ratio( sig, b1 )
	num = sig[1]*sig[2]
	den1= b1[1]*b1[2]

	r = den1 != 0 ?  num/(den1) : 0
	return r
end


"""
	get_SB_ratio( sig, b1, b2 )
Description of ```get_SB_ratio```
------------------------------
Returns signal-to-background ratio defined as: ```r = A₁ε₁ / (A₂ε₂ + A₃ε₃ ) ```

See also get_SB_ratio( sig, b1).
"""
function get_SB_ratio( sig, b1, b2 )
	num = sig[1]*sig[2]
	den1= b1[1]*b1[2]
	den2= b2[1]*b2[2]

	r = (den1 + den2) != 0 ? num/(den1+den2) : 0
	return r
end