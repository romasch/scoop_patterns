note
	description: "Processor-local access to a separate CPS_DEFAULT_QUEUE."
	author: "Roman Schocker"
	date: "$Date$"
	revision: "$Revision$"

class
	CPS_DEFAULT_QUEUE_ACCESS [G]

inherit
	CPS_QUEUE_ACCESS [G, CPS_DEFAULT_QUEUE [G]]

create
	make

feature {NONE} -- Implementation

	put_impl (a_buffer: separate CPS_DEFAULT_QUEUE [G]; an_item: separate G)
			-- Put `an_item' into `a_buffer'
		do
			a_buffer.put (an_item)
		end

	consume_impl (a_buffer: separate CPS_DEFAULT_QUEUE [G]): separate G
			-- Consume an item from `a_buffer'.
		do
			Result := a_buffer.consume
		end


end
