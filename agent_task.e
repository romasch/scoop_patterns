note
	description: "Summary description for {AGENT_TASK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AGENT_TASK

inherit

	TASK

	CELL [detachable separate ROUTINE [ANY, TUPLE]]

create
	put, make_from_separate

feature -- Initialization

	run
			-- <Precursor>
		do
			if attached item as my_item then
				run_controlled (my_item)
			end
		end

	make_from_separate (a_task: separate like Current)
			-- Initialize `Current' from `a_task'.
		do
			put (a_task.item)
		end

feature {NONE} -- Implementation

	run_controlled (ag: attached like item)
		do
			ag.apply
		end



end
