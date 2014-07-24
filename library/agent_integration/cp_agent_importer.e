note
	description: "Importer for agents."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	CP_AGENT_IMPORTER

inherit

	CP_IMPORTER [ROUTINE [ANY, TUPLE]]
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
			create routine_access
			create tuple_importer
			create reflector
			create reflected_agent.make (Current)
		end

feature -- Status report

	is_importable (a_routine: separate ROUTINE [ANY, TUPLE]): BOOLEAN
			-- Is `a_routine' importable?
		local
			l_separate_closed_args: BOOLEAN
			l_no_attributes: BOOLEAN
			l_correct_return_type: BOOLEAN
			l_type_id: INTEGER
		do
				-- First check if the basic requirements hold.
			if is_unsafe_importable (a_routine) then

					-- All closed arguments must be either of a basic type or truly separate.
				l_separate_closed_args := tuple_importer.is_importable (routine_access.get_closed_operands (a_routine))

					-- The type of the target should not define any attributes.
				l_type_id := {ISE_RUNTIME}.dynamic_type (a_routine)
				l_no_attributes := reflector.field_count_of_type (l_type_id) = 0

					-- The return type, if any, must be a basic type or separate.
				l_correct_return_type := to_implement_assertion ("TODO: At the moment there is a limitation in the runtime.")

				Result := l_separate_closed_args and l_no_attributes and l_correct_return_type
			end
		ensure then
			correct_relation: Result implies is_unsafe_importable (a_routine)
		end

	is_unsafe_importable (a_routine: separate ROUTINE [ANY, TUPLE]): BOOLEAN
			-- Is `a_routine' ready for an unsafe import?
		local
			l_operands_void: BOOLEAN
			l_target_open: BOOLEAN
			l_no_result: BOOLEAN
		do
				-- There should not be any open operands from a previous invocation.
			l_operands_void := not attached a_routine.operands

				-- The target must be open.
			l_target_open := not a_routine.is_target_closed

				-- There should not be a result from a previous invocation.
			l_no_result := to_implement_assertion ("Make sure {FUNCTION}.last_result is Void")

			Result := l_operands_void and l_target_open and l_no_result
		ensure
			no_open_operands: Result implies a_routine.operands = Void
			open_target: Result implies not a_routine.is_target_closed
		end

feature -- Basic operations

	import (routine: separate ROUTINE [ANY, TUPLE]): ROUTINE [ANY, TUPLE]
			-- Import `routine' by creating a copy on the local processor.
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
			unsafe_importable: is_unsafe_importable (routine)
		do
			Result := do_import (routine)
		end


feature {NONE} -- Implementation

	tuple_importer: CP_TUPLE_IMPORTER
			-- Importer object for TUPLEs

	routine_access: CP_ROUTINE_ACCESS
			-- Object with privileged access for a routine's attributes.

	reflector: REFLECTOR
			-- Reflection object to create a new agent on the current processor.

	reflected_agent: REFLECTED_REFERENCE_OBJECT
			-- A reflector to initialize newly created agents.

	do_import (routine: separate ROUTINE [ANY, TUPLE]): ROUTINE [ANY, TUPLE]
			-- Import `routine'.
		require
			unsafe_importable: is_unsafe_importable (routine)
		local
			type_id: INTEGER
			i: INTEGER

			integer_field: INTEGER
			boolean_field: BOOLEAN
			pointer_field: POINTER
			reference_field: detachable separate ANY

			l_closed_operands: TUPLE
		do
			fixme ("It may be possible to weaken the harsh precondition a bit: %
				% {ROUTINE}.operands and {FUNCTION}.last_result may be attached - we can just ignore them. %
				% However, this probably implies that some string comparison is necessary here.")

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

					-- Import `open_map', `open_types' and `closed_operands'.
				when reference_type then
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
				else
						-- The above inspect statement should cover all attributes, except maybe `{FUNCTION}.last_result'.
						-- If this check fails, something in ROUTINE or its descendants has changed.
					check only_last_result: reflected_agent.field_name (i) ~ "last_result" end
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
