note
	description: "Queues for data exchange in SCOOP."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CPS_QUEUE [G]

feature -- Access

	capacity: INTEGER
			-- The capacity of `Current'. May be negative if unbounded.

	count: INTEGER
			-- The number of items in `Current'.
		deferred
		end

feature -- Status report

	is_bounded: BOOLEAN
			-- Is `Current' a bounded buffer?
		do
			Result := capacity >= 0
		end

	is_full: BOOLEAN
			-- Is `Current' full?
		do
			Result := not is_bounded or count = capacity
		end

	is_empty: BOOLEAN
			-- Is `Current' full?
		do
			Result := count = 0
		end

feature -- Basic operations



feature {NONE} -- Initialization

	make_bounded (a_capacity: INTEGER)
			-- Create a bounded buffer object with capacity `a_capacity'.
		require
			non_negative: a_capacity >= 0
		deferred
		ensure
			capacity = a_capacity
		end

	make_unbounded
			-- Create an unbounded buffer object.
		deferred
		ensure
			capacity < 0
		end

end
