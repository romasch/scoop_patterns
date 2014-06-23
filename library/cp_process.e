note
	description: "Objects with their own main loop."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CP_PROCESS

inherit
	CP_LAUNCHABLE

feature -- Status report

	is_stopped: BOOLEAN
			-- Is `Current' stopped?

feature -- Basic operations

	step
			-- Perform a step in the computation.
		deferred
		end

	setup
			-- Initialize everything.
		do
		end

	finish
			-- Perform some cleanup.
		do
		end

end
