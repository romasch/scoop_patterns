note
	description: "Objects that call a separate procedure if asked."
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

	operation: separate PROCEDURE [ANY, TUPLE]
			-- The pocedure to be call.

feature -- Basic operations

	start
			-- Call the separate procedure.
		do
			do_start (operation)
		end

feature {NONE} -- Initialization

	make (a_operation: like operation)
			-- Initialization for `Current'.
		do
			operation := a_operation
		end

feature {NONE} -- Implementation

	do_start (a_operation: like operation)
			-- Call `a_operation.call'.
		do
			a_operation.call (Void)
		end

end
