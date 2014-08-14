note
	description: "Summary description for {LES_RAW_SCOOP_SOLVER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	LES_RAW_SCOOP_SOLVER

inherit
	LINEAR_EQUATION_SYSTEM

create
	make_from_array, make_random

feature {NONE} -- Initialization

	make_zero (a_count: INTEGER)
			-- <Precursor>
		local
			l_equation: separate LINEAR_EQUATION
		do
			across
				1 |..| a_count as i
			from
				create equations.make (a_count)
			loop
				create l_equation.make_filled (a_count + 1)
				equations.extend (l_equation)
			end
		end

feature -- Access

	equations: ARRAYED_LIST [separate LINEAR_EQUATION]

	item (i,k: INTEGER): DOUBLE
		do
			Result := eq_get (equations[i], k)
		end

	count: INTEGER
		do
			Result := equations.count
		end

	swap (i,k: INTEGER)
		do
			equations.go_i_th (i)
			equations.swap (k)
		end

	set_item (i, k: INTEGER; value: DOUBLE)
			-- Assign `value' to matrix position [i,k].
		do
			eq_set (equations[i], k, value)
		end

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
				pivot > equations.count or is_singular
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
			minuend.separate_subtract (scalar, equations [pivot])
		end

end
