note
	description: "Summary description for {GAUSS_APPLICATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GAUSS_APPLICATION

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		local
			input: ARRAY [ARRAY [DOUBLE]]
			system: LINEAR_EQUATION_SYSTEM

		do
			input := <<
						<<  2,  1, -1,  8 >>,
						<< -3, -1,  2, -11>>,
						<< -2,  1,  2, -3 >>
					>>

			create system.make_with_array (input)
			system.solve
			print (system)
		end

end
