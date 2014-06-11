note
	description: "Summary description for {WORKER_NEW}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WORKER_NEW [DATA, IMPORTER -> IMPORT_FACTORY [DATA] create default_create end]

feature

	data_pool: separate WORKER_POOL_NEW [DATA, IMPORTER]

	importer: IMPORTER

	start
		do
			from
				is_alive := True
				fetch (data_pool)
			until
				not is_alive
			loop
				if attached last_item as l_item then
					do_work (l_item)
				end
				fetch (data_pool)
			end
		end

	do_work (data: DATA)
		deferred
		end

feature {NONE} -- Loop control instructions.

	make (pool: like data_pool)
		do
			data_pool := pool
			create importer
		end

	fetch (pool: like data_pool)
			-- Fetch the next data item and store the result in `last_item' and `is_alive'.
		require
			not_empty: not pool.is_empty or pool.is_closed
		do

			if pool.is_closed then
				is_alive := False
			else
				last_item := importer.new_from_separate (pool.fetch)
			end
		end

	last_item: detachable DATA

	is_alive: BOOLEAN

end
