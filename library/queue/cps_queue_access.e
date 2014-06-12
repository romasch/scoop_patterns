note
	description: "Processor-local access to a separate CPS_QUEUE object."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	CPS_QUEUE_ACCESS [G, IMPORTER -> CPS_IMPORT_STRATEGY [G] create default_create end]

create
	make

feature -- Access

	buffer: separate CPS_QUEUE [G, IMPORTER]
			-- The separate buffer.

	last_consumed_item: detachable like importer.import
			-- The last consumed item.
			-- The separate status of the result type may vary depending on the chosen import strategy.

feature -- Basic operations

	put (item: separate G)
			-- Put `item' into the buffer.
			-- Note: blocks if `buffer' is full.
		do
			put_impl (buffer, item)
		end

	consume
			-- Remove an item from `buffer' and store it in `last_consumed_item'.
			-- Note: blocks if `buffer' is empty.
		do
			consume_impl (buffer)
		end

feature {NONE} -- Implementation

	put_impl (a_buffer: separate CPS_QUEUE [G, IMPORTER]; an_item: separate G)
			-- Put `an_item' into `a_buffer'
		require
			not_full: not a_buffer.is_full
		do
			a_buffer.put (an_item)
		end

	consume_impl (a_buffer: separate CPS_QUEUE [G, IMPORTER])
			-- Consume an item from `a_buffer'.
		require
			not_empty: not a_buffer.is_empty
		do
			last_consumed_item := importer.import (a_buffer.item)
			a_buffer.remove
		end

feature {NONE} -- Initialization

	make (a_separate_buffer: separate CPS_QUEUE [G, IMPORTER])
			-- Initialization for `Current'.
		do
			buffer := a_separate_buffer
			create importer
		end

	importer: attached IMPORTER
			-- The selected import strategy.

end
