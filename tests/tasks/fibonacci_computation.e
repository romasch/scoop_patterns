note
	description: "Summary description for {FIBONACCI_COMPUTATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FIBONACCI_COMPUTATION

inherit
	CP_COMPUTATION [INTEGER]

create
	make, make_from_separate

feature -- Initialization

	make_from_separate (other: separate like Current)
			-- Initialize `Current' from `other'.
		do
			input := other.input
			future_result := other.future_result
		end

	make (a_input: INTEGER)
			-- Initialization for `Current'.
		do
			input := a_input
		end

feature -- Access

	input: INTEGER

feature -- Basic operations

	compute: INTEGER
			-- <Precursor>
		local
			l_computation: FIBONACCI_COMPUTATION
			l_future: CP_FUTURE [INTEGER, CP_NO_IMPORT [INTEGER]]
			l_starter: CP_FUTURE_STARTER [INTEGER, CP_NO_IMPORT [INTEGER]]
		do
			if input <= 2 then
				Result := 1
			else
				create l_starter
				create l_computation.make (input - 2)
				l_future := l_starter.new_future (l_computation)

				input := input - 1
				Result := compute + l_future.item
			end
		end

end
