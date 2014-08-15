note
	description: "Summary description for {SEQUENTIAL_GAUSS_ELIMINATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEQUENTIAL_GAUSS_ELIMINATION

inherit
	RAW_SCOOP_GAUSS_ELIMINATION
		redefine
			new_equation
		end

create
	make_random

feature {NONE}

	new_equation (a_count: INTEGER): LINEAR_EQUATION
			-- <Precursor>
			-- The return type is narrowed to non-separate, which avoids processor creation.
		do
			create Result.make_filled (a_count)
		end

end
