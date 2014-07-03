note
	description: "Operations that may return a result and can be copied across processors."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CP_COMPUTATION [RESULT_TYPE -> detachable separate ANY]

inherit
	CP_TASK
		redefine
			asynch_token
		end

feature -- Basic operations

	run
			-- Run the current task.
		local
			l_result: RESULT_TYPE
		do
			l_result := compute
			if attached asynch_token as l_token then
				put_result (l_token, l_result)
			end
		end

	compute: RESULT_TYPE
			-- Compute the result.
		deferred
		end

feature {CP_COMPUTATION} -- Implementation

	asynch_token: detachable separate CP_RESULT_BROKER [RESULT_TYPE, CP_IMPORT_STRATEGY[RESULT_TYPE]]

	put_result (a_token: attached like asynch_token; a_result: RESULT_TYPE)
			-- Put `a_result' into `a_cell'.
		do
			a_token.set_item (a_result)
			a_token.finish
		end

end
