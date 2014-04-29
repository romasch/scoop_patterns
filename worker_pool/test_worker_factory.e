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

	new_worker (a_pool: separate WORKER_POOL [STRING]): separate TEST_WORKER
		do
			create Result.make (a_pool)
		end

end
