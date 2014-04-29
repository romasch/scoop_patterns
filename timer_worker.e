note
	description: "Summary description for {TIMER_WORKER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TIMER_WORKER

inherit
	TASK

create make

feature

	run
		local
			env: EXECUTION_ENVIRONMENT
		do
			from
				create env
			until
				check_stopped (timer)
			loop
				do_run (task)
				env.sleep (interval * 1000000)
			end

		end


	timer: separate TIMER

feature {NONE}

	task: separate TASK

	interval: INTEGER
		-- sleep time in milliseconds


	make (a_task: separate TASK; an_interval: INTEGER)
		do
			task := a_task
			interval := an_interval
			create timer.make (Current)
		end


	do_run (a_task: like task)
		do
			a_task.run
		end

	check_stopped (a_timer: like timer): BOOLEAN
		do
			Result := a_timer.is_stopped
		end

end
