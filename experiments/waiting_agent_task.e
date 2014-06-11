note
	description: "Summary description for {WAITING_AGENT_TASK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WAITING_AGENT_TASK

inherit
	AGENT_TASK
		redefine
			run
		end

feature -- Access

	wait_time: INTEGER_64
			-- The wait time in milliseconds before executing the task.

feature -- Element change

	set_wait_time (time: like wait_time)
			-- Set `wait_time' to `time'.
		require
			positve: time >= 0
		do
			wait_time := time
		ensure
			time_set: wait_time = time
		end

feature -- Task execution

	run
			-- <Precursor>
		local
			env: EXECUTION_ENVIRONMENT
		do
			if wait_time > 0 then
				create env
				env.sleep (wait_time * 1000000)
			end

			Precursor
		end

feature {NONE} -- Initialization

	make (an_item: like item; time: like wait_time)
			-- Initialization for `Current'.
		do
			put (an_item)
			set_wait_time (time)
		end

end
