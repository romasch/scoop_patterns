note
	description: "Operations that can be copied across processor boundaries."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CP_TASK

inherit
	CP_IMPORTABLE

feature -- Basic operations

	run
			-- Run the current task.
		deferred
		end

feature -- Initialization

	make_from_separate (other: separate like Current)
			-- Initialize `Current' from `other'.
		deferred
		end

end
