note
	description: "Executor service to run CP_TASK objects."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CP_EXECUTOR

feature -- Basic operations

	put (a_task: separate CP_TASK)
			-- Execute `a_task'.
		deferred
		end

	put_with_broker (a_task: separate CP_TASK): separate CP_BROKER
			-- Execute `a_task' and return a broker object.
		deferred
		end

end
