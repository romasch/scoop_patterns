note
	description: "Summary description for {WORKER_POOL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WORKER_POOL [DATA]

create
	make

feature -- Work submission

	submit (data_package: separate DATA)
			-- Submit `data_package' to the pool to be executed by a worker processor.
		do
			buffer.extend (data_package)
		end


feature -- Controls

	enlarge (count: INTEGER)
			-- Add `count' new workers to the pool.
		local
			i: INTEGER
			worker: separate WORKER [separate DATA]
		do
			from
				i := 1
			until
				i > count
			loop
				internal_add_worker (factory)
				i := i + 1
			variant
				count + 1 - i
			end
		end

	close
			-- Close all worker processors.
		do
			is_closed := True
		end


feature -- Status report

	is_empty: BOOLEAN
			-- Is the work queue of `Current' empty?
		do
			Result := buffer.is_empty
		end

	is_closed: BOOLEAN
			-- Is the worker pool closed?

feature {WORKER}

	fetch: separate DATA
		require
			not_empty: not is_empty
			not_closed: not is_closed
		do
			Result := buffer.item
			buffer.remove
		end


feature {NONE} -- Implementation

	make (a_factory: separate WORKER_FACTORY [separate DATA])
			-- Initialization for `Current'.
		do
			is_closed := False
			factory := a_factory
			create buffer.make (100)
			create workers.make (10)
		end

	buffer: ARRAYED_QUEUE [separate DATA]

	workers: ARRAYED_LIST [separate WORKER [separate DATA]]

	factory: separate WORKER_FACTORY [separate DATA]

	internal_add_worker (fact: like factory)
		local
			worker: separate WORKER [separate DATA]
		do
			worker := fact.new_worker (Current)
			workers.extend (worker)
			internal_start_worker (worker)
		end

	internal_start_worker (worker: separate WORKER [separate DATA])
		do
			worker.start
		end

end
