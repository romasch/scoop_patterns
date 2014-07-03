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
			broker
		end

feature -- Access

	broker: detachable separate CP_SHARED_RESULT_BROKER [RESULT_TYPE, CP_IMPORT_STRATEGY[RESULT_TYPE]]
			-- <Precursor>

feature -- Basic operations

	run
			-- <Precursor>
		local
			l_result: RESULT_TYPE
		do
			l_result := compute
			if attached broker as l_token then
				put_result (l_token, l_result)
			end
		end

	compute: RESULT_TYPE
			-- Compute the result.
		deferred
		end

feature {CP_COMPUTATION} -- Implementation

	put_result (a_token: attached like broker; a_result: RESULT_TYPE)
			-- Put `a_result' into `a_cell'.
		do
			a_token.set_item (a_result)
			a_token.terminate
		end

end
