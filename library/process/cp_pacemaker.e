note
	description: "Objects that call `iteration' on a separate CP_INTERMITTENT_PROCESS."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	CP_PACEMAKER

inherit
	CP_LAUNCHABLE

create
	make

feature -- Access

	process: separate CP_INTERMITTENT_PROCESS
			-- The separate process.

feature -- Basic operations

	start
			-- Call the separate procedure.
		do
			do_start (process)
		end

feature {NONE} -- Initialization

	make (a_process: like process)
			-- Initialization for `Current'.
		do
			process := a_process
		end

feature {NONE} -- Implementation

	do_start (a_process: like process)
			-- Call `a_process.iteration'.
		do
			a_process.iteration
		end

end
