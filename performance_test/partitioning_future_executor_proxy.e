note
	description: "A future executor proxy that can use its own broker processor."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PARTITIONING_FUTURE_EXECUTOR_PROXY [G, IMPORTER -> CP_IMPORT_STRATEGY [G] create default_create end]

inherit
	CP_FUTURE_EXECUTOR_PROXY [G, IMPORTER]

create
	make

feature -- Status setting

	enable_private_processor
			-- Use a private processor for promise objects.
		do
			create my_promise_processor
			create my_result_promise_processor
		end

end
