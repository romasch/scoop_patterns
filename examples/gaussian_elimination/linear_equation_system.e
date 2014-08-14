note
	description: "A solver for a system of linear equations which uses the future pattern."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	LES_FUTURE_SOLVER

inherit
	LINEAR_EQUATION_SYSTEM

create
	make, make_random, make_from_array

feature {NONE} -- Initialization

	make_zero (a_count: INTEGER)
			-- <Precursor>
		local
			l_equation: LINEAR_EQUATION
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

	make (a_equations: ARRAYED_LIST [LINEAR_EQUATION])
			-- Initialize `Current' with all equations in `a_equations'.
		require
			correct_dimensions: a_equations.count = a_equations [1].count - 1
			uniform: across a_equations as cursor all cursor.item.count = a_equations [1].count end
		do
			equations := a_equations
		end

feature -- Access

	item (row_index, column_index: INTEGER): DOUBLE
			-- <Precursor>
		do
			Result := equations [row_index].i_th (column_index)
		end

	count: INTEGER
			-- <Precursor>
		do
			Result := equations.count
		end

	equations: ARRAYED_LIST [LINEAR_EQUATION]
			-- The linear equations in the system.

feature -- Basic operations

	set_item (i, k: INTEGER; value: DOUBLE)
			-- Assign `value' to matrix position [i,k].
		do
			equations [i].put_i_th (value, k)
		end

	swap (i, k: INTEGER)
			-- Swap rows i and k.
		do
			equations.go_i_th (i)
			equations.swap (k)
		end

feature -- Advanced operations

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
			create worker_pool.make (50, 4)
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

end
