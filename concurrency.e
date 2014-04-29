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

	new_timer (task: separate TASK; interval: INTEGER): separate TIMER
		local
			worker: separate TIMER_WORKER
		do
			create worker.make (task, interval)
			Result := get_timer (worker)
		end

	get_timer (blub: separate TIMER_WORKER): separate TIMER
		do
			Result := blub.timer
		end

	future (task: separate FUTURE_TASK [separate ANY]): separate FUTURE [separate ANY]
		do
			Result := task.token
			task.run
		end


	asynch (a_feature: detachable separate ROUTINE [ANY, TUPLE]; milliseconds: INTEGER)

		do
			if attached a_feature then
				do_run (internal_task, a_feature, milliseconds)
			end
		end

	asynch_unordered (a_feature: detachable separate ROUTINE [ANY, TUPLE]; milliseconds: INTEGER)
			-- Execute a feature fully asynchronously.
		local
			executor: separate EXECUTOR
			task:  separate WAITING_AGENT_TASK
		do
			if attached a_feature then
				create task
				do_run (task, a_feature, milliseconds)
			end

--			if attached a_feature as ag then
--				create executor
--				do_execute (executor, a_feature)
--			end
		end

	internal_task: separate WAITING_AGENT_TASK
		once ("THREAD")
			create Result
		end

	do_run (task: separate WAITING_AGENT_TASK; a_feature: separate ROUTINE [ANY, TUPLE]; milliseconds: INTEGER)
		do
			task.put (a_feature)
			task.set_wait_time (milliseconds)
			task.run
		end

	do_execute (executor: separate EXECUTOR; a_feature: detachable separate ROUTINE [ANY, TUPLE])
		do
			if attached a_feature as feat then
				executor.execute (feat)
			end
		end
end
