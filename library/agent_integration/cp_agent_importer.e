note
	description: "Importer for agents."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	CP_AGENT_IMPORTER

inherit

	CP_IMPORT [ROUTINE [ANY, TUPLE]]
		redefine
			is_importable,
			default_create
		end

	REFLECTOR_CONSTANTS
		undefine
			default_create
		end

	REFACTORING_HELPER
		undefine
			default_create
		end

feature {NONE} -- Initialization

	default_create
			-- <Precursor>
		do
			create tuple_importer
			create reflector
			create reflected_agent.make (Current)
		end

feature -- Status report

	is_importable (an_agent: separate ROUTINE [ANY, TUPLE]): BOOLEAN
			-- Is `an_agent' importable?
		do
			fixme ("TODO")
			-- All closed args expanded or truly separate
			-- Target open, no attributes
			-- Return type separate or expanded.
			Result := True
		end

	import (routine: separate ROUTINE [ANY, TUPLE]): ROUTINE [ANY, TUPLE]
			-- <Precursor>
		do
			Result := do_import (routine)
		end

	unsafe_import (routine: separate ROUTINE [ANY, TUPLE]): ROUTINE [ANY, TUPLE]
			-- Import `routine' by creating a copy on the local processor.
			-- Note: This function is dangerous, as it may introduce traitors or Void calls.
			-- Make sure you follow these two rules:
			--- All closed arguments are either expanded or declared as separate.
			--- The agent must never access its target (i.e. no implicit or explicit use of Current).
		require
			open_target: not routine.is_target_closed
		do
			Result := do_import (routine)
		end


feature {NONE} -- Implementation

	tuple_importer: CP_TUPLE_IMPORTER
			-- Importer object for TUPLEs

	reflector: REFLECTOR
			-- Reflection object to create a new agent on the current processor.

	reflected_agent: REFLECTED_REFERENCE_OBJECT
			-- A reflector to initialize newly created agents.


	do_import (routine: separate ROUTINE [ANY, TUPLE]): ROUTINE [ANY, TUPLE]
			-- Import `routine'.
		require
			open_operands_void: not attached routine.operands
			no_result: to_implement_assertion ("Make sure {FUNCTION}.last_result is Void.")
		local
			type_id: INTEGER
			i: INTEGER

			integer_field: INTEGER
			boolean_field: BOOLEAN
			pointer_field: POINTER
			reference_field: detachable separate ANY

			l_closed_operands: TUPLE
		do
			type_id := {ISE_RUNTIME}.dynamic_type (routine)

				-- Should succeed because `type_id' is a valid type.
			check attached {ROUTINE [ANY, TUPLE [ANY]]} reflector.new_instance_of (type_id) as res then
				Result := res
			end

			from
				reflected_agent.set_object (Result)
				i := 1
			until
				i > reflector.field_count_of_type (type_id)
			loop

				inspect
					reflector.field_type_of_type (i, type_id)

					-- Copy `open_count', `routine_id' and `written_type_id_inline_agent'.
				when integer_32_type then
					integer_field := {ISE_RUNTIME}.integer_32_field (i, $routine, 0)
					reflected_agent.set_integer_32_field (i, integer_field)

					-- Copy `is_basic' and `is_target_closed'.
				when boolean_type then
					boolean_field := {ISE_RUNTIME}.boolean_field (i, $routine, 0)
					reflected_agent.set_boolean_field (i, boolean_field)

					-- Copy `calc_rout_addr', `encaps_rout_disp' and `rout_disp'.
				when pointer_type then
					pointer_field := {ISE_RUNTIME}.pointer_field (i, $routine, 0)
					reflected_agent.set_pointer_field (i, pointer_field)

				else -- Reference field

					reference_field := {ISE_RUNTIME}.reference_field (i, $routine, 0)

						-- Import `open_map' and `open_types'.
					if attached {separate ARRAY[INTEGER]} reference_field as array then
						reflected_agent.set_reference_field (i, import_array (array))

						-- Import `closed_operands'.
						-- The attribute `operands' cannot fall into this branch - it is
						-- Void because of the precondition.
					elseif attached {separate TUPLE} reference_field as tuple then
						l_closed_operands := tuple_importer.unsafe_import (tuple)
						reflected_agent.set_reference_field (i, l_closed_operands)

					else
							-- The remaining items could be `operands' and `{FUNCTION}.last_result'.
							-- Both of them must be Void.
						check no_more_items: reference_field = Void end
					end
				end
				i := i + 1
			end
		end

	import_array (array: separate ARRAY [INTEGER]): ARRAY [INTEGER]
			-- Import an integer array.
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

end
