note
	description: "Summary description for {LINEAR_EQUATION}."
	author: ""
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

create

	make, make_with_values, make_from_separate

feature {NONE} -- Initialization

	make_with_values (vector: READABLE_INDEXABLE [DOUBLE])
			-- Initialize with values from `a_vector'.
		do
			make (1)
			across
				vector as cell
			loop
				extend (cell.item)
			end
		end

	make_from_separate (other: separate LINEAR_EQUATION)
			-- <Precursor>
		local
			idx, l_count: INTEGER
		do
			l_count := other.count
			make (l_count)

			from
				idx := 1
			until
				idx > l_count
			loop
				extend (other [idx])
				idx := idx + 1
			end
		end

feature -- Mathematical operations

	subtract (scalar: DOUBLE; subtrahend: LINEAR_EQUATION): LINEAR_EQUATION
			-- Subtract `scalar' times `subtrahend' from `Current'.
		require
			same_count: subtrahend.count = count
		local
			minuend: LINEAR_EQUATION
			idx: INTEGER
		do
			from
				idx := 1
				minuend := Current
				create Result.make (count)
			until
				idx > count
			loop
				Result.extend ( minuend [idx] - scalar * subtrahend [idx])
				idx := idx + 1
			end
		end

feature -- Searching

	find_nonzero: INTEGER
			-- The index of the first non-zero element.
			-- Negative if all elements are zero.
		do
			from
				Result := 1
			until
				Current [Result] /= 0.0 or Result > count
			loop
				Result := Result + 1
			end

			if Result > count then
				Result := -1
			end
		end

end
