note
	description: "Summary description for {CP_PACEMAKER}."
	author: ""
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
			-- The agent to call.

feature -- Basic operations

	start
			-- <Precursor>
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
