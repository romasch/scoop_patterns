note
	description: "Operations that may return a result and can be copied across processors."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	COMPUTATION [RESULT_TYPE]

inherit
	TASK

feature -- Access

	last_result: detachable RESULT_TYPE
			-- The result of the computation represented by `Current'.

end
