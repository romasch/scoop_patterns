note
	description: "Utility functions to access a separate CP_EXECUTOR object."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	CP_EXECUTOR_UTILS

feature -- Basic operations

	executor_put (a_executor: separate CP_EXECUTOR; a_task: separate CP_TASK)
			-- Put `a_task' in `a_executor'.
		do
			a_executor.put (a_task)
		end

	executor_stop (a_executor: separate CP_EXECUTOR)
			-- Stop `a_executor'.
		do
			a_executor.stop
		end

end
