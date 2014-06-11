note
	description: "Processor-local access to a separate CPS_IMPORTING_QUEUE."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	CPS_FACTORY_IMPORTING_QUEUE_ACCESS [G]

inherit
	CPS_QUEUE_ACCESS [G, CPS_FACTORY_IMPORTING_QUEUE [G]]

create
	make

feature

	put_impl (a_buffer: separate CPS_FACTORY_IMPORTING_QUEUE [G]; an_item: separate G)
			-- Put `an_item' into `a_buffer'
		do
		end

	consume_impl (a_buffer: separate CPS_FACTORY_IMPORTING_QUEUE [G]): separate G
			-- Consume an item from `a_buffer'.
		local
			res: detachable G
		do
			check attached res as r then Result := r end
		end

end
