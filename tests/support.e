note
	description: "Summary description for {SUPPORT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SUPPORT

feature

	new_tuple_with_expanded: TUPLE [ETEST]
		local
			l_exp: ETEST
		do
			create l_exp
			Result := [l_exp]
		end

	wrap (obj: detachable separate ANY): TUPLE [detachable separate ANY]
		do
			Result := [obj]
		end

end
