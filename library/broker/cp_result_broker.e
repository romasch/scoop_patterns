note
	description: "Shared broker objects that can import the result of a separate task."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CP_RESULT_BROKER [G]

inherit
	CP_BROKER

feature -- Access

	item: detachable separate G
			-- The generated result.
			-- May be void in case of an exception.
		require
			terminated: is_terminated
		deferred
		end

end
