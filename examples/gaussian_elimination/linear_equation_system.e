note
	description: "Summary description for {LINEAR_EQUATION_SYSTEM}."
	author: ""
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
	make, make_with_array

feature {NONE} -- Initialization

	make_with_array (array: ARRAY [ARRAY [DOUBLE]])
			-- Initialization for `Current'.
		do
			create equations.make (array.count)

			across
				array as cursor
			loop
				equations.extend (create {LINEAR_EQUATION}.make_with_values (cursor.item))
			end
		end

	make (a_equations: ARRAYED_LIST [LINEAR_EQUATION])
		do
			equations := a_equations
		end

feature -- Access

	equations: ARRAYED_LIST [LINEAR_EQUATION]
			-- The row of coefficients.

feature --  Basic operations

	solve
			-- Solve the system using gaussian elimination.
		local
			executor: CP_FUTURE_EXECUTOR_PROXY [LINEAR_EQUATION, CP_STATIC_TYPE_IMPORTER [LINEAR_EQUATION]]
			brokers: ARRAYED_QUEUE [CP_RESULT_BROKER_PROXY [LINEAR_EQUATION, CP_STATIC_TYPE_IMPORTER [LINEAR_EQUATION]]]

			task: ROW_SUBTRACTION_TASK
			index: INTEGER
			k: INTEGER
		do
			create executor.make_global
			create brokers.make (equations.count)

			from
				index := 1
			until
				index > equations.count
			loop
					-- Start all futures.
				from
					k := index + 1
				until
					k > equations.count
				loop
					create task.make (equations [index], equations [k])
					brokers.put (executor.put_future (task))
					k := k + 1
				end

					-- Write back the results.
				from
					k := index + 1
				until
					k > equations.count
				loop
					check attached brokers.item.item as l_item then
						equations [k] := l_item
					end
					brokers.remove
					k := k + 1
				end
				index := index + 1
			end
			executor.stop

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

invariant
	correct: equations.count + 1 = equations [1].count
end
