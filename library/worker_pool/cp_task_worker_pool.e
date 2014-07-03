note
	description: "Summary description for {CP_TASK_WORKER_POOL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CP_TASK_WORKER_POOL

inherit

	CP_WORKER_POOL [CP_TASK, CP_DYNAMIC_TYPE_IMPORTER [CP_TASK]]

	CP_WORKER_FACTORY [CP_TASK, CP_DYNAMIC_TYPE_IMPORTER [CP_TASK]]

	CP_EXECUTOR

create
	make

feature {NONE} -- Initialization

	make (buffer_size: INTEGER; worker_count: INTEGER)
			-- Initialization for `Current'.
		do
			initialize_buffer (buffer_size)
			initialize_factory (worker_count, Current)
		end

feature {NONE} -- Worker factory

	new_worker (a_pool: separate CP_TASK_WORKER_POOL): separate CP_TASK_WORKER
			-- Create a new worker belonging to `a_pool'.
		do
			create Result.make (Current)
		end

end
