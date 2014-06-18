note
	description: "Objects that produce strings and put them in a shared buffer."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PRODUCER

create
	make


feature {NONE} -- Initialization

	make (a_queue: separate CP_QUEUE [STRING, CPS_STRING_IMPORTER]; a_id: INTEGER)
			-- Initialization for `Current'.
		do
			identifier := a_id
			create queue_wrapper.make (a_queue)
		end

	queue_wrapper: CP_QUEUE_PROXY [STRING, CPS_STRING_IMPORTER]
			-- A wrapper object to a separate queue.

	identifier: INTEGER
			-- Identifier of `Current'.

feature -- Basic operations

	produce (items_to_produce: INTEGER)
			-- Produce `items_to_produce' items.
		local
			i: INTEGER
			item: STRING
		do
			from
				i := 1
			until
				i > items_to_produce
			loop
					-- Note that there's no need to declare `item' as separate, because
					-- it will be imported anyway.
				item := "Producer: " + identifier.out + ": item " + i.out
				queue_wrapper.put (item)
				i := i + 1
			end
		end

end
