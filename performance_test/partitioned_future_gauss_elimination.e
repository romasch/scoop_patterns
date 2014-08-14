note
	description: "Summary description for {PARTITIONED_FUTURE_GAUSS_ELIMINATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PARTITIONED_FUTURE_GAUSS_ELIMINATION

inherit
	FUTURE_GAUSS_ELIMINATION
		redefine
			solve
		end

create
	make_random, make_from_array

feature -- Constants

	Partitions: INTEGER = 2

feature -- Advanced operations

	solve
			-- Precursor
		local
			l_worker_pool: separate CP_TASK_WORKER_POOL
			l_executor: PARTITIONING_FUTURE_EXECUTOR_PROXY [LINEAR_EQUATION, CP_STATIC_TYPE_IMPORTER [LINEAR_EQUATION]]
			executors: SPECIAL [CP_FUTURE_EXECUTOR_PROXY [LINEAR_EQUATION, CP_STATIC_TYPE_IMPORTER [LINEAR_EQUATION]]]

			promises: ARRAYED_QUEUE [CP_RESULT_PROMISE_PROXY [LINEAR_EQUATION, CP_STATIC_TYPE_IMPORTER [LINEAR_EQUATION]]]

			task: ROW_SUBTRACTION_TASK
			pivot: INTEGER
			k: INTEGER
		do

				-- Initialize the worker pools.
			across
				1 |..| Partitions as i
			from
				create executors.make_empty (Partitions)
			loop
				create l_worker_pool.make (50, 2)
				create l_executor.make (l_worker_pool)
				l_executor.enable_private_processor
				executors.extend (l_executor)
			end

			create promises.make (equations.count)

			from
				pivot := 1
			until
				pivot > count or is_singular
			loop
					-- The pivot should not be zero.
					-- Swap rows if necessary.
				adjust_rows (pivot)

					-- Check if there is a non-zero pivot.
				if not is_singular then

						-- Start all futures.
					from
						k := pivot + 1
					until
						k > count
					loop
						create task.make (equations [pivot], equations [k], pivot)
						promises.put (executors [k \\ partitions].put_future (task))
						k := k + 1
					end

						-- Write back the results.
					from
						k := pivot + 1
					until
						k > count
					loop
							-- May block if the result is not yet available.
						check attached promises.item.item as l_item then
							equations [k] := l_item
						end
						promises.remove
						k := k + 1
					end
				end

				pivot := pivot + 1
			variant
				count + 1 - pivot
			end

				-- Stop the worker pools such that the application can terminate.
			across
				executors as cursor
			loop
				cursor.item.stop
			end
		end

end
