note
	description: "Processor-local access to a separate CP_WORKER_POOL."
	author: "Roman Schmocker"
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

	utils: CP_WORKER_POOL_UTILS [G]
			-- Helper functions to access a separate worker pool.

feature -- Access

	worker_pool: separate CP_WORKER_POOL [G, CP_IMPORT_STRATEGY [G]]
			-- The worker pool to which `Current' acts as a proxy.

	actual_worker_count: INTEGER
			-- The actual number of workers in `worker_pool'.
		do
			Result := utils.wp_actual_worker_count (worker_pool)
		end

	preset_worker_count: INTEGER
			-- The number of workers that `worker_pool' should have.
		do
			Result := utils.wp_preset_worker_count (worker_pool)
		end

feature -- Basic operations

	put (a_work: separate G)
			-- Submit `a_work' to the worker pool.
			-- May block if the worker pool buffer is full.
		do
			utils.queue_put (worker_pool, a_work)
		end

	set_worker_count (a_count: INTEGER)
			-- Set the number of workers to `a_count'
		do
			utils.wp_set_worker_count (worker_pool, a_count)
		end

	stop
			-- Stop the worker pool.
		do
			utils.wp_stop (worker_pool)
		end

end
