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

create make

feature {NONE} -- Initialization

	make (a_executor: like executor)
			-- Initialization for `Current'.
		do
			executor := a_executor
		end

feature -- Access

	executor: separate CP_EXECUTOR
			-- The actual executor.

feature -- Basic operations

	put (a_task: separate CP_TASK)
			-- <Precursor>
		do
			executor_put (executor, a_task)
		end

	put_with_broker (a_task: separate CP_TASK): CP_BROKER_PROXY
			-- Execute `a_task' asynchronously and return a broker object.
		local
			l_broker: separate CP_SHARED_BROKER
		do
			l_broker := new_broker (broker_processor)
			a_task.set_broker (l_broker)
			create {CP_BROKER_PROXY} Result.make (l_broker)

			put (a_task)
		end

feature {NONE} -- Implementation

	executor_put (a_executor: like executor; a_task: separate CP_TASK)
			-- Put `a_task' in `a_executor'.
		do
			a_executor.put (a_task)
		end

end
