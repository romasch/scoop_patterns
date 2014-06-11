note
	description: "Summary description for {WORKER_FACTORY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WORKER_FACTORY [DATA]

feature

	new_worker (a_pool: separate WORKER_POOL [DATA]): separate WORKER [DATA]
		deferred
		end

end
