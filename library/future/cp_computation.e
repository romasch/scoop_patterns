note
	description: "Operations that may return a result and can be copied across processors."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CP_COMPUTATION [RESULT_TYPE -> detachable separate ANY]

inherit
	CP_TASK

feature -- Initialization

	make_from_separate (other: separate like Current)
			-- Initialize `Current' from `other'.
		deferred
		ensure then
			same_future_result: future_result = other.future_result
		end

feature -- Basic operations

	run
			-- Run the current task.
		local
			l_result: RESULT_TYPE
		do
			l_result := compute
			if attached future_result as l_future_result then
				put_result (l_future_result, l_result)
			end
		end

	compute: RESULT_TYPE
			-- Compute the result.
		deferred
		end

feature {CP_FUTURE_STARTER} -- Implementation

	set_future_result (a_future_result: like future_result)
			-- Initialize `future_result'.
		do
			future_result := a_future_result
		end

feature {CP_COMPUTATION} -- Implementation

	future_result: detachable separate CP_RESULT_CELL [RESULT_TYPE, CP_IMPORT_STRATEGY[RESULT_TYPE]]

	put_result (a_cell: attached like future_result; a_result: RESULT_TYPE)
			-- Put `a_result' into `a_cell'.
		do
			a_cell.set_item (a_result)
		end

end
