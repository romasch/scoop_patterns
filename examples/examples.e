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
			app: APPLICATION
			buffer: separate CPS_DEFAULT_QUEUE_ACCESS [ANY]
			asdf: separate CPS_IMPORTING_QUEUE_ACCESS [CPS_IMPORTABLE]

			queue: separate CPS_QUEUE [EXAMPLES, CPS_STATIC_TYPE_IMPORTER [EXAMPLES]]
			acc: CPS_QUEUE_ACCESS [EXAMPLES, CPS_STATIC_TYPE_IMPORTER [EXAMPLES]]

			ex: EXAMPLES
		do
			--create app.make

			create queue.make_unbounded
			create acc.make (queue)

			acc.put (create {EXAMPLES})
			acc.put (create {separate EXAMPLES})

			acc.consume
			if attached acc.last_consumed_item as it then
				print ("Hello ")
				ex := it
			end

		end

	make_from_separate (other: separate EXAMPLES) do end

end
