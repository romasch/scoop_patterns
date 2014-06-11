note
	description: "Utility class to import an agent."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	AGENT_IMPORTER

inherit
	REFLECTOR_CONSTANTS

feature -- Access

feature -- Measurement

feature -- Status report

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

	import_agent (ag: separate PROCEDURE [ANY, TUPLE [ANY]]): PROCEDURE [ANY, TUPLE [ANY]]
		require
			-- only target open and not set
			-- valid closed args
			-- if return type: separate or expanded!
		local
			reflector: REFLECTOR
			agent_reflector: REFLECTED_REFERENCE_OBJECT
			type_id: INTEGER
			i: INTEGER

			integer_field: INTEGER
			boolean_field: BOOLEAN
			pointer_field: POINTER

			field_name: STRING

			l_closed_operands: TUPLE
		do
			create reflector
			type_id := ag.generating_type.type_id

			check attached {PROCEDURE [ANY, TUPLE [ANY]]} reflector.new_instance_of (type_id) as res then
				Result := res
			end

			from
				create agent_reflector.make (Result)
				i := 1
			until
				i > reflector.field_count_of_type (type_id)
			loop
				inspect
					reflector.field_type_of_type (i, type_id)

				when integer_32_type then
					integer_field := {ISE_RUNTIME}.integer_32_field (i, $ag, 0)
					agent_reflector.set_integer_32_field (i, integer_field)
				when boolean_type then
					boolean_field := {ISE_RUNTIME}.boolean_field (i, $ag, 0)
					agent_reflector.set_boolean_field (i, boolean_field)
				when pointer_type then
					pointer_field := {ISE_RUNTIME}.pointer_field (i, $ag, 0)
					agent_reflector.set_pointer_field (i, pointer_field)

				else -- Reference field

					field_name := reflector.field_name_of_type (i, type_id)
					if field_name ~ "closed_operands" then
						if attached {separate TUPLE} {ISE_RUNTIME}.reference_field (i, $ag, 0) as sep_tuple then
							l_closed_operands := tuple_importer.import_tuple (sep_tuple)
							agent_reflector.set_reference_field (i, l_closed_operands)
						end
--						l_closed_operands := tuple_importer.import_tuple (tuple: separate TUPLE)
--						agent_reflector.set_reference_field (i, [])
					elseif field_name ~ "open_map" then
						if attached {separate ARRAY[INTEGER]} {ISE_RUNTIME}.reference_field (i, $ag, 0) as sep_arr then
							agent_reflector.set_reference_field (i, import_int_array (sep_arr))
						end
						--agent_reflector.set_reference_field (i, create {ARRAY[INTEGER]}.make_filled (1, 1, 1))
					end
				end
				i := i + 1
			end
		end

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

	tuple_importer: TUPLE_IMPORTER
		attribute create Result end

	import_int_array (array: separate ARRAY [INTEGER]): ARRAY [INTEGER]
		local
			min, max: INTEGER
			i: INTEGER
		do
			min := array.lower
			max := array.upper
			create Result.make_filled (-1, min, max)

			from
				i := min
			until
				i > max
			loop
				Result [i] := array [i]
				i := i + 1
			end
		end

invariant
	invariant_clause: True -- Your invariant here

end
