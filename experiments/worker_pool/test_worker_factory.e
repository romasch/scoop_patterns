note
	description: "Summary description for {TEST_WORKER_FACTORY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_WORKER_FACTORY

inherit
	WORKER_FACTORY [STRING]

feature

	id: INTEGER
		attribute Result := 1 end

	new_worker (a_pool: separate WORKER_POOL [STRING]): separate TEST_WORKER
		do
			create Result.make (a_pool)
			put_id (Result)
		end

	put_id (w: like new_worker)
		do
			w.put_id (id)
			id := id + 1
		end

end
