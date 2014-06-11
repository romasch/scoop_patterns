note
	description: "Summary description for {TIMER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TIMER

	-- Note: A processor-local TIMER and a hidden communicator object (the current TIMER) might be more user friendly.

create make

feature

	make (a_worker: like worker)
		do
			worker := a_worker
		end

--	is_started: BOOLEAN

	is_stopped: BOOLEAN

	start
		do
			do_start (worker)
			--is_started := True
		end

	stop
		do
			is_stopped := True
		end

feature {NONE}

	do_start (a_worker: like worker) do a_worker.run end

	worker: separate TIMER_WORKER

end
