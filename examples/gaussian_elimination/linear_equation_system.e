note
	description: "Representation for a system of linear equations."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	LINEAR_EQUATION_SYSTEM

inherit
	ANY
		redefine
			out
		end

create
	make, make_from_array

feature {NONE} -- Initialization

	make_from_array (array: ARRAY [ARRAY [DOUBLE]])
			-- Initialize `Current' with the values in `array'.
		require
			correct_dimensions: array.count = array [1].count - 1
			uniform: across array as cursor all cursor.item.count = array [1].count end
		local
			l_equation: LINEAR_EQUATION
		do
			create equations.make (array.count)

			across
				array as cursor
			from
				create equations.make (array.count)
			loop
				across
					cursor.item as cell
				from
					create l_equation.make (cursor.item.count)
					equations.extend (l_equation)
				loop
					l_equation.extend (cell.item)
				end
			end
		end

	make (a_equations: ARRAYED_LIST [LINEAR_EQUATION])
			-- Initialize `Current' with all equations in `a_equations'.
		require
			correct_dimensions: a_equations.count = a_equations [1].count - 1
			uniform: across a_equations as cursor all cursor.item.count = a_equations [1].count end
		do
			equations := a_equations
		end

feature -- Access

	equations: ARRAYED_LIST [LINEAR_EQUATION]
			-- The linear equations in the system.

feature --  Basic operations

	solve
			-- Solve the system of linear equations using gaussian elimination.
		local
			worker_pool: separate CP_TASK_WORKER_POOL
			executor: CP_FUTURE_EXECUTOR_PROXY [LINEAR_EQUATION, CP_STATIC_TYPE_IMPORTER [LINEAR_EQUATION]]
			promises: ARRAYED_QUEUE [CP_RESULT_PROMISE_PROXY [LINEAR_EQUATION, CP_STATIC_TYPE_IMPORTER [LINEAR_EQUATION]]]

			task: ROW_SUBTRACTION_TASK
			index: INTEGER
			k: INTEGER
		do
				-- Initialize the worker pool.
			create worker_pool.make (20, 4)
			create executor.make (worker_pool)


			from
				index := 1
				create promises.make (equations.count)
			until
				index > equations.count
			loop
					-- The pivot should not be zero.
					-- Swap rows if necessary.
				adjust_rows (index)

					-- Check if there is a non-zero pivot.
				if equations [index].array_item (index) /= 0 then

						-- Start all futures.
					from
						k := index + 1
					until
						k > equations.count
					loop
						create task.make (equations [index], equations [k], index)
						promises.put (executor.put_future (task))
						k := k + 1
					end

						-- Write back the results.
					from
						k := index + 1
					until
						k > equations.count
					loop
							-- May block if the result is not yet available.
						check attached promises.item.item as l_item then
							equations [k] := l_item
						end
						promises.remove
						k := k + 1
					end

				else
						-- All remaining items in this column are zero, and the
						-- matrix is singular. Skip the remaining computation.
					index := equations.count
				end
				index := index + 1
			variant
				equations.count + 1 - index
			end

				-- Stop the worker pool such that the application can terminate.
			executor.stop
		end

	adjust_rows (pivot: INTEGER)
			-- Swap row if necessary to get a non-zero pivot element.
		local
			k: INTEGER
		do
			from
				k := pivot + 1
			until
				k > equations.count or (equations [pivot]) [pivot] /= 0.0
			loop
				if (equations [k])[pivot] /= 0.0 then
					equations.go_i_th (k)
					equations.swap (pivot)
				end
				k := k + 1
			end
		end

feature -- Output

	out: STRING
			-- <Precursor>
		do
			create Result.make_empty
			across
				equations as eq
			loop
				across
					eq.item  as cell
				loop
					Result.append (cell.item.out + "%T")
				end
				Result.append ("%N")
			end
		end
end
