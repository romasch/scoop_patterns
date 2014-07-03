note
	description: "Processor-local access to a separate CP_EXECUTOR object."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	CP_EXECUTOR_PROXY

inherit
	CP_EXECUTOR

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

	put_with_broker (a_task: separate CP_TASK): CP_BROKER
			-- <Precursor>
		local
			l_result: CP_BROKER_PROXY
		do
			create l_result.make (executor_put_with_broker (executor, a_task))
			Result := l_result
		end

feature {NONE} -- Implementation

	executor_put (a_executor: like executor; a_task: separate CP_TASK)
			-- Put `a_task' in `a_executor'.
		do
			a_executor.put (a_task)
		end

	executor_put_with_broker (a_executor: like executor; a_task: separate CP_TASK): separate CP_BROKER
			-- Put `a_task' in `a_executor' and return a broker.
		do
			Result := a_executor.put_with_broker (a_task)
		end

end
