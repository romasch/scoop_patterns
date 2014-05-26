note
	description: "[
		One possibility to hide separateness of FUTURE. API provides 2 way to check that future is ready:
		1. Check `is_available' in the client code. If it is `TRUE', the result is available immediately
		2. Directly call `item'. This will block the client processor, until the result is actually available 
		(which may never happen).
		]"
	author: "Alexey Kolesnichenko"
	date: "$Date$"
	revision: "$Revision$"

expanded class
	FUTURE_RESULT[G -> attached separate ANY]
inherit ANY
redefine
	default_create
end
create
	default_create, from_future
feature -- API
	is_available: BOOLEAN
	do
		Result := is_available_internal (future)
	end

	item : separate G
	do
		Result := item_internal(future)
	end

feature{NONE} -- creation
	future: separate FUTURE[G]

	default_create
	do
		--dummy future, just to make void-safety happy.
		create future
	end

	from_future( a_future: separate FUTURE[G])
	do
		future := a_future
	end

feature {NONE} -- implementation
	is_available_internal(a_future: separate FUTURE[G]) : BOOLEAN
	do
		Result:= a_future.is_available
	end

	item_internal(a_future: separate FUTURE[G]) : separate G
	require
		a_future.is_available
	do
		Result:= a_future.item
	end
end
