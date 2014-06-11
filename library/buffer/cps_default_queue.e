note
	description:
	"[
		Normal queues that do not perform any copies.
		This queue is suitable for expanded types or 
		very big objects, such as images.
		
		Note:
		Any object which gets inserted in this queue must
		be either expanded or have its own processor, in
		order to avoid deadlocks and undue waiting.
	]"
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	CPS_DEFAULT_QUEUE [G]

inherit
	CPS_QUEUE [G]

create
	make_bounded, make_unbounded

feature -- Access

	count: INTEGER
			-- <Precursor>
		do
			Result := my_queue.count
		end

feature {CPS_DEFAULT_QUEUE_ACCESS}

	put (item: separate G)
		do
			my_queue.put (item)
		end

	consume: separate G
		do
			Result := my_queue.item
			my_queue.remove
		end


feature {NONE} -- Initialization

	my_queue: ARRAYED_QUEUE [separate G]

	make_bounded (a_capacity: INTEGER)
			-- Create a bounded buffer object with capacity `a_capacity'.
		do
			capacity := a_capacity
			create my_queue.make (a_capacity)
		end

	make_unbounded
			-- Create an unbounded buffer object.
		do
			create my_queue.make (2)
			capacity := -1
		end

end
