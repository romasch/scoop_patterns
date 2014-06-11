note
	description: "Processor-local access to a separate CPS_QUEUE object."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CPS_QUEUE_ACCESS [G, BUFFER_TYPE -> CPS_QUEUE[G]]


feature -- Access

	buffer: separate BUFFER_TYPE
			-- The separate buffer.

	last_consumed_item: detachable like consume_impl

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
			last_consumed_item := consume_impl (buffer)
		end

feature {NONE} -- Implementation

	put_impl (a_buffer: separate BUFFER_TYPE; an_item: separate G)
			-- Put `an_item' into `a_buffer'
		require
			not_full: not a_buffer.is_full
		deferred
		end

	consume_impl (a_buffer: separate BUFFER_TYPE): separate G
			-- Consume an item from `a_buffer'.
		require
			not_empty: not a_buffer.is_empty
		deferred
		end

feature {NONE} -- Initialization

	make (a_separate_buffer: separate BUFFER_TYPE)
		do
			buffer := a_separate_buffer
		end

end
