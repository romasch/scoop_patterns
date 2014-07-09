note
	description: "Summary description for {CP_WORKER_POOL_PROXY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CP_WORKER_POOL_PROXY [G]

create
	make

feature {NONE} -- Initialization

	make (a_pool: separate like worker_pool)
			-- Initialization for `Current'.
		do
			worker_pool := a_pool
			create utils
		end

	utils: CP_QUEUE_UTILS [G]

feature -- Access

	worker_pool: separate CP_WORKER_POOL [G, CP_IMPORT_STRATEGY [G]]

	worker_count: INTEGER

feature -- Basic operations

	submit (a_work_item: separate G)
			-- Submit `a_work_item' to the worker pool.
			-- May block if the worker pool buffer is full.
		do
			utils.queue_put (worker_pool, a_work_item)
		end

	set_worker_count (a_count: INTEGER)
			-- Set the number of workers to `a_count'
		do
			(
			agent (a_pool: separate like worker_pool; i: INTEGER)
				do
					a_pool.set_worker_count (i)
				end
			).call ([worker_pool, a_count])
		end

	stop
			-- Stop the worker pool.
		do
			set_worker_count (0)
		end

end
