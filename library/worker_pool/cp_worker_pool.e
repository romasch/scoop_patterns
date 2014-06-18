note
	description: "Worker pools that accept work items of type G."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	CP_WORKER_POOL [G, IMPORTER -> CPS_IMPORT_STRATEGY [G] create default_create end]

inherit
	CPS_QUEUE [G, IMPORTER]

	CP_PROCESS_LAUNCHER

create
	make

feature {NONE} -- Initialization

	make (buffer_size: INTEGER; worker_count: INTEGER; a_worker_factory: separate CP_WORKER_FACTORY [G, IMPORTER])
			-- Initialization for `Current'.
		do
			if buffer_size > 0 then
				make_bounded (buffer_size)
			else
				make_unbounded
			end

			worker_factory := a_worker_factory
			preset_worker_count := worker_count

			adjust (worker_factory)
		end

feature -- Access

	preset_worker_count: INTEGER
			-- The number of workers `Current' should have.

	actual_worker_count: INTEGER
			-- The actual number of workers in `Current'.

feature -- Worker control

	set_worker_count (a_size: INTEGER)
			-- Adjust the preset number of workers in `Current'.
		require
			positove: a_size > 0
		do
			preset_worker_count := a_size
			adjust (worker_factory)
		end

	stop
			-- Stop all workers in `Current'.
		do
			preset_worker_count := 0
		end

feature {CP_WORKER} -- Worker support

	is_stop_requested: BOOLEAN
			-- Does the worker need to stop?
		do
			Result := actual_worker_count > preset_worker_count
		end

	remove_actual_worker
			-- Decrease the number of active workers.
		do
			actual_worker_count := actual_worker_count - 1
		end

feature {NONE} -- Implementation

	worker_factory: separate CP_WORKER_FACTORY [G, IMPORTER]
			-- A factory for new worker objects.

	adjust (a_factory: like worker_factory)
			-- Add new workers to the pool if necessary.
		local
			l_worker: separate CP_WORKER [G, IMPORTER]
		do
			from
			until
				actual_worker_count >= preset_worker_count
			loop
				l_worker := a_factory.new_worker (Current)
				launch (l_worker)
				actual_worker_count := actual_worker_count + 1
			end
		end
end