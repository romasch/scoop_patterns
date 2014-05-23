note
	description: "Summary description for {TEST_WORKER_FACTORY_NEW}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_WORKER_FACTORY_NEW

inherit
	WORKER_FACTORY_NEW [STRING, TEST_IMPORT_FACTORY]

feature

	new_worker (a_pool: separate WORKER_POOL_NEW [STRING, TEST_IMPORT_FACTORY]): separate TEST_WORKER_NEW
		do
			create Result.make (a_pool)
		end


end
