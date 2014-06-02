note
	description: "Utility class to import a tuple object."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	TUPLE_IMPORTER

feature -- Access

feature -- Measurement

feature -- Status report

	is_valid_for_import (tuple: separate TUPLE): BOOLEAN
			-- Is `tuple' valid for an import?
			-- A tuple is valid if it only contains basic types or separate references.
		local
			l_index: INTEGER
			l_count: INTEGER
		do
			from
				l_index := 1
				l_count := tuple.count
				Result := True
			until
				l_index > l_count
			loop
				if tuple.is_reference_item (l_index) then
					Result := Result and is_tuple_item_separate (tuple, l_index)
				end
				l_index := l_index + 1
			variant
				l_count + 1 - l_index
			end
		end

	is_tuple_item_separate (tuple: separate TUPLE; index: INTEGER): BOOLEAN
			-- Does the item at `tuple[index]' have a different handler than `tuple'?
		require
			valid_index: 1 <= index and index <= tuple.count
			reference_item: tuple.is_reference_item (index)
		do
			Result := c_is_tuple_item_separate (tuple, index)
		end

feature -- Status setting

feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

	import_tuple (tuple: separate TUPLE): TUPLE
			-- Copy `tuple' to the handler of `Current'.
		require
			valid: is_valid_for_import (tuple)
		local
			l_tuple_type_id: INTEGER
			l_reflector: REFLECTOR
		do
			l_tuple_type_id := tuple.generating_type.type_id
			create l_reflector

				-- This tuple creation should always succeed, because the type is exactly the same.
			check attached l_reflector.new_tuple_from_tuple (l_tuple_type_id, tuple) as l_result then
				Result := l_result
			end
		ensure
			same_count: Result.count = tuple.count
			correct_copy: across 1 |..| Result.count as idx all tuple [idx.item] = Result [idx.item] end
			same_type: Result.generating_type ~ tuple.generating_type
		end

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

	c_is_tuple_item_separate (a_tuple: separate TUPLE; a_index: INTEGER): BOOLEAN
			-- Is the handler of `a_tuple' different from the handler of `a_tuple[a_index]'?
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
