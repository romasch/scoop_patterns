note
	description : "all_examples application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	EXAMPLES

inherit CPS_IMPORTABLE

create
	make, make_from_separate, default_create

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			example_loader: detachable separate ANY

			app: APPLICATION

			queue: separate CPS_QUEUE [EXAMPLES, CPS_STATIC_TYPE_IMPORTER [EXAMPLES]]
			acc: CPS_QUEUE_ACCESS [EXAMPLES, CPS_STATIC_TYPE_IMPORTER [EXAMPLES]]

			ex: EXAMPLES

			imp: CPS_DYNAMIC_TYPE_IMPORTER [EXAMPLES]
		do
			--create app.make

--			create queue.make_unbounded
--			create acc.make (queue)

--			acc.put (create {EXAMPLES})
--			acc.put (create {separate EXAMPLES})

--			acc.consume
--			if attached acc.last_consumed_item as it then
--				print ("Hello ")
--				ex := it
--			end

			example_loader := create {PRODUCER_CONSUMER}.make

		end

	make_from_separate (other: separate EXAMPLES) do end

end
