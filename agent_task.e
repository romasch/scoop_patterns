note
	description: "Summary description for {AGENT_TASK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AGENT_TASK

inherit
	TASK

create
	make

feature -- Initialization

	my_agent: separate ROUTINE [ANY, TUPLE]

	make (ag: like my_agent)
			-- Initialization for `Current'.
		do
			my_agent := ag
		end

	run
		do
			across 1|..| 1000000 as i loop do_nothing end
			run_controlled (my_agent)
		end

	run_controlled (ag: like my_agent)
		do
			ag.call (Void)
		end

end
