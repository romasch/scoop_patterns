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
			-- May block if full.
		do
			utils.executor_put (subject, a_task)
		end

	put_with_promise (a_task: separate CP_TASK): CP_PROMISE_PROXY
			-- Execute `a_task' asynchronously and return a promise.
		local
			l_promise: separate CP_SHARED_PROMISE
		do
			l_promise := new_promise (my_promise_processor)
			a_task.set_promise (l_promise)
			create Result.make (l_promise)
			put (a_task)
		ensure
			same_promise: Result.subject = a_task.promise
		end

	stop
			-- <Precursor>
		do
			utils.executor_stop (subject)
		end

feature {NONE} -- Implementation

	my_promise_processor: separate CP_PROMISE_UTILS
			-- The processor to be used for promise objects.
		attribute
			Result := promise_processor
		end

end
