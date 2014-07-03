note
	description: "Executor service to run CP_TASK objects asynchronously."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CP_EXECUTOR

feature -- Basic operations

	put (a_task: separate CP_TASK)
			-- Execute `a_task' asynchronously.
		deferred
		end

end
