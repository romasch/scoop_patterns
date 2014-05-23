note
	description: "Summary description for {WORKER_FACTORY_NEW}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"


deferred class
	WORKER_FACTORY_NEW [DATA, IMPORTER -> IMPORT_FACTORY [DATA] create default_create end]

feature

	new_worker (a_pool: separate WORKER_POOL_NEW [DATA, IMPORTER]): separate WORKER_NEW [DATA, IMPORTER]
		deferred
		end

end
