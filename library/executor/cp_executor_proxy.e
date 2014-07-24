note
	description: "Processor-local access to a separate CP_EXECUTOR object."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	CP_EXECUTOR_PROXY

inherit

	CP_EXECUTOR

	CP_GLOBAL_PROCESSORS

	CP_PROXY [CP_EXECUTOR, CP_EXECUTOR_UTILS]

create
	make, make_global

feature {NONE} -- Initialization

	make_global
			-- Initialize `Current' with the global worker pool.
		local
			l_procs: CP_GLOBAL_PROCESSORS
		do
			create l_procs
			make (l_procs.global_worker_pool)
		end

feature -- Basic operations

	put (a_task: separate CP_TASK)
			-- <Precursor>
		do
			utils.executor_put (subject, a_task)
		end

	put_with_broker (a_task: separate CP_TASK): CP_BROKER_PROXY
			-- Execute `a_task' asynchronously and return a broker object.
		local
			l_broker: separate CP_SHARED_BROKER
		do
			l_broker := new_broker (broker_processor)
			a_task.set_broker (l_broker)
			create Result.make (l_broker)
			put (a_task)
		ensure
			same_broker: Result.broker = a_task.broker
		end

	stop
			-- <Precursor>
		do
			utils.executor_stop (subject)
		end

end
