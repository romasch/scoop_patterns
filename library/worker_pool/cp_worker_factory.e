note
	description: "Factory for new worker objects."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CP_WORKER_FACTORY [G, IMPORTER -> CPS_IMPORT_STRATEGY [G] create default_create end]

feature

	new_worker (a_pool: separate CP_WORKER_POOL [G, IMPORTER]): separate CP_WORKER [G, IMPORTER]
			-- Create a new worker belonging to `a_pool'.
		deferred
		end

end
