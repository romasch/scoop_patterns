note
	description: "Summary description for {CP_AGENT_TASK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CP_AGENT_TASK

inherit
	CP_TASK

create
	make_safe, make_from_separate

feature {NONE} -- Initialization

	make_safe (a_routine: like routine)
			-- Initialize `Current' with `a_routine'.
		require
			importable: (create {CP_AGENT_IMPORTER}).is_importable (a_routine)
		do
			routine := a_routine
		end

	make_unsafe (a_routine: like routine)
			-- Initialize `Current' wiht `a_routine'.
			-- Note: This function is dangerous, as it may introduce traitors or Void calls.
			-- Make sure you follow these two rules:
			--- All closed arguments are either expanded or declared as separate.
			--- The agent must never access its target (i.e. no implicit or explicit use of Current).
		require
			open_target: not a_routine.is_target_closed
		do
			routine := a_routine
		end

	make_from_separate (other: separate like Current)
			-- <Precursor>
		local
			importer: CP_AGENT_IMPORTER
		do
			create importer
			routine := importer.import (other.routine)
		end

feature -- Access

	routine: ROUTINE [ANY, TUPLE]
			-- The agent to run.

feature -- Basic operations

	run
			-- <Precursor>
		do
			routine.call (Void)
		end

end
