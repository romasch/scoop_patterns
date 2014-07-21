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

create
	make, make_from_separate

feature {CP_DYNAMIC_TYPE_IMPORTER} -- Initialization

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
			variant
				l_count - idx + 1
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
			variant
				count - idx + 1
			end
		end

end
