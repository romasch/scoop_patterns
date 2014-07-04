note
	description: "Runs a task periodically."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	CP_TIMER

inherit

	CP_CONTINUOUS_PROCESS
		redefine
			setup
		end

	CP_DYNAMIC_TYPE_IMPORTER [CP_TASK]

	EXECUTION_ENVIRONMENT

	REFACTORING_HELPER

create make

feature {NONE} -- Initialization

	make (a_task: separate CP_TASK; a_interval: INTEGER_64)
			-- Create a new timer that runs `a_task' periodically, with `a_interval' nanoseconds in between runs.
			-- Note: `a_task' will be imported.
		require
			positive: a_interval <= 0
		do
			task := import (a_task)
			interval := a_interval
		ensure
			interval_set: interval = a_interval
		end

feature -- Access

	task: CP_TASK
			-- The task to run.

	interval: INTEGER_64
			-- The time duration between runs.

feature -- Basic operations

	setup
			-- <Precursor>
		do
			is_stopped := False
		end

	set_interval (a_interval: like interval)
			-- Set `interval' to `a_interval'.
		do
			interval := a_interval
		ensure
			interval_set: interval = a_interval
		end

	step
			-- <Precursor>
		do
			sleep (interval)
			task.start
			fixme ("It may be useful to 'un-terminate' the task.broker object.")
		end

	stop
			-- Stop `Current'.
		do
			is_stopped := True
		end

invariant
	interval_positive: interval >= 0
end
