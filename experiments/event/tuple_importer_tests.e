note
	description: "Summary description for {TUPLE_IMPORTER_TESTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TUPLE_IMPORTER_TESTS [G -> TUPLE]

inherit
	TUPLE_IMPORTER

create
	test_importer, default_create

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
			check attached {G} import_tuple (tuple) as res then Result := res end
--			create l_reflector
--			dynamic_type := get_type (tuple.generating_type)

----			print (l_reflector.type_of_type (dynamic_type))

--			if attached  {G} l_reflector.new_tuple_from_tuple (dynamic_type, tuple) as res then
--				Result := res
--			end

----			from
----				i := tuple.count
----			until
----				i = 0
----			loop
----				Result [i] := tuple [i]
----				i := i - 1
----			variant
----				i + 1
----			end

		end



	is_separate (o1, o2: detachable separate ANY): BOOLEAN
		do
			if attached o1 and attached o2 then
				Result := is_separate_impl (o1, o2)
			else
				Result := False
			end
		end

	is_separate_impl (o1, o2: attached separate ANY): BOOLEAN
		external
			"C inline use %"eif_macros.h%""
		alias
			"return (EIF_BOOLEAN) EIF_IS_DIFFERENT_PROCESSOR (eif_access($o1), eif_access($o2))"
		end

	print_types
		local
			t: TUPLE [ANY, detachable separate ANY]
			int: INTERNAL
		do
			t := [create {ANY}, create {separate ANY}]
--			t := [create {ANY}, Void]
			create int
			print (is_tuple_item_separate (t, 1))
			print (is_tuple_item_separate (t, 2))
--			print (int.generic_dynamic_type (t, 1))
--			print (is_separate (t, t[1]))
--			print (int.generic_dynamic_type (t, 2))
--			print (is_separate (t, t[2]))
		end

	test_importer
		local
			factory: separate TUPLE_TEST_FACTORY
			int_import: TUPLE_IMPORTER_TESTS [TUPLE [INTEGER, INTEGER]]
			any_import: TUPLE_IMPORTER_TESTS [TUPLE [ANY]]
		do
			create factory
			do_test (factory)
			print_types
		end

	do_test (factory: separate TUPLE_TEST_FACTORY)
		local
			int_import: TUPLE_IMPORTER_TESTS [TUPLE [INTEGER, INTEGER]]
			cell_import: TUPLE_IMPORTER_TESTS [TUPLE [ANY]]
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
				-- fixed now.
			if attached {TUPLE [cell: CELL [INTEGER]]} cell_import.import (factory.test_ref) as ci then
				cell_tup := ci
				print (cell_tup)
				print (cell_tup.cell.item) -- Traitor !
			end

		end

end
