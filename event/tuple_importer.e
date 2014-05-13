note
	description: "Summary description for {TUPLE_IMPORTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TUPLE_IMPORTER [G -> TUPLE]

feature

	get_type (type: separate TYPE [detachable separate ANY]): INTEGER
		do
			Result := type.type_id
		end

	import (tuple: attached separate G): detachable G
		local
			dynamic_type: INTEGER
			i: INTEGER
			l_reflector: INTERNAL
		do
			create l_reflector
			dynamic_type := get_type (tuple.generating_type)

--			print (l_reflector.type_of_type (dynamic_type))

			if attached  {G} l_reflector.new_tuple_from_tuple (dynamic_type, tuple) as res then
				Result := res
			end

--			from
--				i := tuple.count
--			until
--				i = 0
--			loop
--				Result [i] := tuple [i]
--				i := i - 1
--			variant
--				i + 1
--			end

		end

	test_importer
		local
			factory: separate TUPLE_TEST_FACTORY
			int_import: TUPLE_IMPORTER [TUPLE [INTEGER, INTEGER]]
			any_import: TUPLE_IMPORTER [TUPLE [ANY]]
		do
			create factory
			do_test (factory)
		end

	do_test (factory: separate TUPLE_TEST_FACTORY)
		local
			int_import: TUPLE_IMPORTER [TUPLE [INTEGER, INTEGER]]
			cell_import: TUPLE_IMPORTER [TUPLE [ANY]]
			int_tup: attached separate TUPLE [INTEGER, INTEGER]
			cell_tup: TUPLE [cell: CELL [INTEGER]]

		do
			create int_import
			create cell_import

			int_tup := factory.test_integer
			if attached int_import.import (int_tup) as something then
				print (something)
			else
				print ("Void%N")
			end

				-- The test should fail... Type must be TUPLE [separate CELL [INTEGER]]
			if attached {TUPLE [cell: CELL [INTEGER]]} cell_import.import (factory.test_ref) as ci then
				cell_tup := ci
				print (cell_tup)
				print (cell_tup.cell.item) -- Traitor !
			end


		end

end
