note
	description: "Queues for data exchange in SCOOP."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	CPS_QUEUE [G, IMPORTER -> CPS_IMPORT_STRATEGY [G] create default_create end]

create
	make_bounded, make_unbounded

feature -- Access

	capacity: INTEGER
			-- The capacity of `Current'. May be negative if unbounded.

	count: INTEGER
			-- The number of items in `Current'.
		do
			Result := store.count
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
			Result := is_bounded and count = capacity
		end

	is_empty: BOOLEAN
			-- Is `Current' full?
		do
			Result := count = 0
		end

feature -- Basic operations

	put (a_item: separate G)
		do
			store.put (importer.import (a_item))
		end

	item: separate G
		do
			Result := store.item
		end

	remove
		do
			store.remove
		end

feature {NONE} -- Initialization

	make_bounded (a_capacity: INTEGER)
			-- Create a bounded buffer object with capacity `a_capacity'.
		require
			non_negative: a_capacity >= 0
		do
			capacity := a_capacity
			create store.make (a_capacity)
			create importer
		ensure
			capacity = a_capacity
		end

	make_unbounded
			-- Create an unbounded buffer object.
		do
			capacity := -1
			create store.make (1)
			create importer
		ensure
			capacity < 0
		end

	store: ARRAYED_QUEUE [separate G]
			-- The internal storage for `Current'.

	importer: attached IMPORTER

end
