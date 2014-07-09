note
	description: "Summary description for {ROW_SUBTRACTION_TASK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ROW_SUBTRACTION_TASK

inherit

	CP_COMPUTATION [LINEAR_EQUATION]

create
	make, make_from_separate

feature {NONE} -- Initialization

	make (a_subtrahend: like subtrahend; a_minuend: like minuend)
			-- Initialization for `Current'.
		do
			subtrahend := a_subtrahend
			minuend := a_minuend
		end

	make_from_separate (other: separate like Current)
			-- <Precursor>
		do
			create subtrahend.make_from_separate (other.subtrahend)
			create minuend.make_from_separate (other.minuend)
			broker := other.broker
		end


feature -- Access

	minuend: LINEAR_EQUATION
			-- The base row to be subtracted from.	

	subtrahend: LINEAR_EQUATION
			-- The subtrahend row.

feature -- Basic operations

	compute: LINEAR_EQUATION
			-- <Precursor>
		local
			pivot: INTEGER
			scalar: DOUBLE
		do
				-- Find the first non-zero entry in the input.	
			pivot := minuend.find_nonzero

				-- Calculate the scalar value.
			scalar := minuend [pivot] / subtrahend [pivot]

				-- Do the row subtraction.
			Result := minuend.subtract (scalar, subtrahend)
		end

end
