note
	description: "Summary description for {CONCURRENCY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CONCURRENCY

feature

	call (function: separate ROUTINE [ANY, TUPLE])
			-- Universal enclosing routine
		do
			function.call (Void)
		end

	asynch (a_feature: separate ROUTINE [ANY, TUPLE])
			-- Execute a feature fully asynchronously.
		local
			executor: separate EXECUTOR
		do
			create executor
			across 1 |..| 1000000 as i loop do_nothing  end
			do_execute (executor, a_feature)
		end


	do_execute (executor: separate EXECUTOR; a_feature: separate ROUTINE [ANY, TUPLE])
		do
			executor.execute (a_feature)
		end
end
