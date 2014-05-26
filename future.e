note
	description: "Summary description for {FUTURE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FUTURE [G -> attached separate ANY]

	-- Note: A processor-local FUTURE and a hidden communicator object (the current FUTURE) might be more user friendly.

feature -- Access

	item: separate G
			-- The result of `Current'
		require
			available: is_available
		do
			check from_invariant: attached internal_item as res then
				Result := res
			end
		end

feature -- Status report
	future_result : FUTURE_RESULT[G]
	do
		create Result.from_future(Current)
	end

	is_available: BOOLEAN
		-- Has the computation of `item' finished?

feature -- Element change

	put (an_item: like item)
			-- Assign `item' with `an_item'.
		do
			internal_item := an_item
			is_available := True
		ensure
			available: is_available
			correct: item = an_item
		end

feature {NONE} -- Helper functions

	internal_item: detachable separate G
			-- The actual storage for `item'.
end
