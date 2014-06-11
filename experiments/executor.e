note
	description: "Summary description for {EXECUTOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EXECUTOR

inherit
	CONCURRENCY

create
	default_create

feature

	execute (a_feature: separate ROUTINE [ANY, TUPLE])
			-- Execute a feature.
		do
			across 1 |..| 1000000 as i loop do_nothing end
			a_feature.call (Void)
--			call (a_feature)
		end

end
