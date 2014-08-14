note
	description: "A system of linear equations that uses raw SCOOP mechanisms for gaussian elimination."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	RAW_SCOOP_GAUSS_ELIMINATION

inherit
	LINEAR_EQUATION_SYSTEM [separate LINEAR_EQUATION]

create
	make_from_array, make_random

feature -- Access

	item (i,k: INTEGER): DOUBLE
		do
			Result := eq_get (equations[i], k)
		end

feature -- Basic operations

	set_item (i, k: INTEGER; value: DOUBLE)
			-- Assign `value' to matrix position [i,k].
		do
			eq_set (equations[i], k, value)
		end

feature -- Advanced operations

	solve
			-- Solve the system of linear equations using gaussian elimination.
		local
			pivot: INTEGER
			k: INTEGER

			pivot_value: DOUBLE
		do
			from
				pivot := 1
			until
				pivot > count or is_singular
			loop
					-- Find the pivot with the biggest absolute value.
				adjust_rows (pivot)

				if not is_singular then

						-- Start all computations
					from
						k := pivot + 1
						pivot_value:= eq_get (equations[pivot], (pivot))
					until
						k > equations.count
					loop
						eq_subtract (equations[k], pivot, pivot_value)
						k := k + 1
					end

				end
				pivot := pivot + 1
			variant
				equations.count + 1 - pivot
			end
		end

feature {NONE} -- Implemntation

	new_equation (a_count: INTEGER): separate LINEAR_EQUATION
			-- <Precursor>
		do
			create Result.make_filled (a_count)
		end

feature {NONE} -- Implementation: SCOOP helper functions

	eq_get (equation: separate LINEAR_EQUATION; i:  INTEGER): DOUBLE
		do
			Result := equation [i]
		end

	eq_set (equation: separate LINEAR_EQUATION; i: INTEGER; value: DOUBLE)
		do
			equation [i] := value
		end

	eq_subtract (minuend: separate LINEAR_EQUATION; pivot: INTEGER; pivot_value: DOUBLE)
		local
			scalar: DOUBLE
		do
			scalar := minuend [pivot] / pivot_value
			minuend.subtract (scalar, equations [pivot])
		end

end
