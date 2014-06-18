note
	description: "Objects that consume strings form a shared buffer."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	CONSUMER

create
	make

feature {NONE} -- Initialization

	make (a_queue: separate CPS_QUEUE [STRING, CPS_STRING_IMPORTER]; a_id: INTEGER)
			-- Initialization for `Current'.
		do
			identifier := a_id
			create queue_wrapper.make (a_queue)
		end

	queue_wrapper: CPS_QUEUE_ACCESS [STRING, CPS_STRING_IMPORTER]
			-- A wrapper object to a separate queue.

	identifier: INTEGER
			-- Identifier of `Current'.

feature -- Basic operations

	consume (items_to_consume: INTEGER)
			-- Consume `items_to_consume' items.
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i > items_to_consume
			loop
				queue_wrapper.consume

				check attached queue_wrapper.last_consumed_item as item then
						-- Note that `item' is not declared as separate, because it has been
						-- imported automatically.

					print (item + " // Consumer " + identifier.out + ": item " + i.out + "%N")
				end
				i := i + 1
			end
		end

end
