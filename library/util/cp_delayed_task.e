note
	description: "Tasks that wrap around other tasks and can be used to introduce a small delay before execution."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	CP_DELAYED_TASK

inherit

	CP_TASK

create
	make, make_from_separate

feature {NONE} -- Initialization

	make (a_task: CP_TASK; a_delay: like delay)
			-- Create `Current' with `a_task' and `a_delay' (in nanoseconds).
		require
			positive_delay: a_delay >= 0
		do
			task := a_task
			initialize (a_delay)
		ensure
			delay_set: delay = a_delay
			broker_set: broker = a_task.broker
			equal_task: task ~ a_task
			initialized: is_initialized
		end

	initialize (a_delay: like delay)
			-- Finish initializion of `Current'.
		require
			task_initialized: attached task
		do
			delay := a_delay
--			broker := task.broker
			create environment
			is_initialized := True
		ensure
			delay_set: delay = a_delay
			broker_set: broker = task.broker
			initialized: is_initialized
		end

feature {CP_DYNAMIC_TYPE_IMPORTER}-- Initialization

	make_from_separate (other: separate like Current)
			-- <Precursor>
		local
			importer: CP_DYNAMIC_TYPE_IMPORTER [CP_TASK]
		do
			create importer
			task := importer.import (other.task)
			initialize (other.delay)
		ensure then
			same_delay: delay = other.delay
			same_broker: broker = other.broker
			initialized: is_initialized
		end

feature -- Access

	broker: detachable separate CP_SHARED_BROKER
			-- A stable communication object.
		do
			Result := task.broker
		end

	delay: INTEGER_64
			-- The delay time in nanoseconds.

	task: CP_TASK
			-- The task to be executed.

feature -- Basic operations

	set_broker (a_broker: like broker)
			-- Always alias the broker object.
		do
--			broker := a_broker
			task.set_broker (a_broker)
		ensure then
			aliased: a_broker = task.broker
		end

	run
			-- <Precursor>
		do
			environment.sleep (delay)
				-- Invoke `run' as opposed to `start', because exception handling is done in `Current'.
			task.run
		end

feature {NONE} -- Implementation

	is_initialized: BOOLEAN
			-- Is `Current' correctly initialized?

	environment: EXECUTION_ENVIRONMENT
			-- An execution environment instance.

invariant
	broker_aliased: is_initialized implies broker = task.broker
end
