note
	description: "Importer for TUPLE objects."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	CP_TUPLE_IMPORTER

inherit
	CP_IMPORT [TUPLE]
		redefine
			is_importable
		end

feature -- Status report

	is_importable (tuple: separate TUPLE): BOOLEAN
			-- Is `tuple' importable?
			-- A tuple is safely importable if it only contains
			-- basic types or truly separate references.
		local
			l_index: INTEGER
			l_count: INTEGER
		do
			from
				l_index := 1
				l_count := tuple.count
				Result := True
			until
				l_index > l_count or not Result
			loop
				if tuple.is_reference_item (l_index) then
					Result := Result and c_is_tuple_item_separate (tuple, l_index)
				end
				l_index := l_index + 1
			variant
				l_count + 1 - l_index
			end
		end

feature -- Duplication

	import (tuple: separate TUPLE): TUPLE
			-- Import `tuple' by creating a copy on the local processor.
		do
			Result := do_import (tuple)
		ensure then
			same_count: Result.count = tuple.count
			correct_copy: across 1 |..| Result.count as idx all tuple [idx.item] = Result [idx.item] end
			same_type: Result.generating_type ~ tuple.generating_type
		end

	unsafe_import (tuple: separate TUPLE): TUPLE
			-- Import `tuple' by creating a copy on the local processor.
			-- Note: This function is very dangerous, as it may introduce traitors.
			-- Make sure you only pass TUPLE objects where all references
			-- objects are declared separate.
		do
			Result := do_import (tuple)
		ensure
			same_count: Result.count = tuple.count
			correct_copy: across 1 |..| Result.count as idx all tuple [idx.item] = Result [idx.item] end
			same_type: Result.generating_type ~ tuple.generating_type
		end

feature {NONE} -- Implementation

	do_import (tuple: separate TUPLE): TUPLE
			-- Import `tuple' using some reflection.
		local
			l_tuple_type_id: INTEGER
			l_reflector: REFLECTOR
		do
			l_tuple_type_id := {ISE_RUNTIME}.dynamic_type (tuple)
			create l_reflector

				-- This tuple creation should always succeed, because the type is exactly the same.
			check attached l_reflector.new_tuple_from_tuple (l_tuple_type_id, tuple) as l_result then
				Result := l_result
			end
		end

	c_is_tuple_item_separate (a_tuple: separate TUPLE; a_index: INTEGER): BOOLEAN
			-- Is `a_tuple[a_index]' truly separate from  `a_tuple'?
		require
			valid_index: 1 <= a_index and a_index <= a_tuple.count
			reference_item: a_tuple.is_reference_item (a_index)
		external
			"C inline use  %"eif_rout_obj.h%", %"eif_macros.h%""
		alias
			"[
				EIF_REFERENCE l_tuple;
				EIF_REFERENCE l_item;
				EIF_BOOLEAN l_result;
				
					/* Get the unprotected reference to `a_tuple' */
				l_tuple = eif_access ($a_tuple);
				
					/* Load the Eiffel object at `a_tuple[index]' */
				l_item = eif_reference_item(l_tuple, $a_index);

					/* l_item may be Void */
				if (l_item) {
						/* Check if the processor ID is different. */
					l_result = EIF_IS_DIFFERENT_PROCESSOR (l_tuple, l_item);
				}
				else {
					l_result = EIF_FALSE;
				}
				return l_result;
			]"
		end

end
