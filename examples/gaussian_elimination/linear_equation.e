note
	description: "Contains the coefficients for a linear equation."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	LINEAR_EQUATION

inherit

	ARRAYED_LIST [DOUBLE]

	CP_IMPORTABLE
		undefine
			copy, is_equal
		end

	MEMORY
		undefine
			copy, is_equal
		end

create
	make, make_filled, make_from_separate

feature {CP_DYNAMIC_TYPE_IMPORTER} -- Initialization

	make_from_separate (other: separate LINEAR_EQUATION)
			-- <Precursor>
		local
			idx, l_count: INTEGER
		do
			l_count := other.count
			make_filled (l_count)

			collection_off
			area.base_address.memory_copy (other.area.base_address, l_count * {PLATFORM}.real_64_bytes)
			collection_on

--			from
--				idx := 1
--			until
--				idx > l_count
--			loop
--				extend (other [idx])
--				idx := idx + 1
--			variant
--				l_count - idx + 1
--			end
		rescue
			collection_on
		end

feature -- Mathematical operations

	subtract (scalar: DOUBLE; subtrahend: LINEAR_EQUATION)
			-- Subtract `scalar' times `subtrahend' from `Current'.
		require
			same_count: subtrahend.count = count
		local
			minuend: LINEAR_EQUATION
			idx: INTEGER
		do
--			create Result.make_filled (count)
			minus (subtrahend, Current, scalar)
		end

	separate_subtract (scalar: DOUBLE; subtrahend: separate LINEAR_EQUATION)
		do
			minus (subtrahend, Current, scalar)
		end

	minus (subtrahend, difference: separate LINEAR_EQUATION; scalar: DOUBLE)
			-- Compute `Current' - `scalar' * `subtrahend' and store the result in `difference'.
			-- `difference' may be the same as `Current'.
		require
			same_count: count = subtrahend.count and subtrahend.count = difference.count
			not_equal: Current /= subtrahend
		local
			i: INTEGER
			minuend: LINEAR_EQUATION
		do
			from
				i := 1
				minuend := Current
			until
				i > count
			loop
				difference [i] :=  minuend [i] - scalar * subtrahend [i]
				i := i + 1
			variant
				count - i + 1
			end
		end

end
