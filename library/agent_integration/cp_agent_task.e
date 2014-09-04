note
	description: "[
		Task object that execute an agent. 
		
		Note: There are several restrictions imposed on the imported agent.
		The first three items originate from {CP_AGENT_IMPORTER}:
		
		1)  Every closed argument has to be either truly separate or a basic
			expanded type. It is NOT sufficient to just declare the argument 
			as separate, as this cannot	be checked due to a runtime limitation.
			
		2)  The target must be open.
		
		3)  There must not be any leftovers from a previous call, 
			i.e. `operands' and {FUNCTION}.last_result must be Void.

		4)  The type of the target must not declare any attributes.
			This is because the target has to be created reflectively
			and provided to the agent uninitialized.
		
		5)  Except for the target, the agent must not have open arguments.
		
		The creation procedure `make_unsafe' does not check rules 1)
		and 4). If you want to use it, make sure that every closed
		argument is declared as	separate, and that the agent never 
		touches an attribute of its target (implicitly or explicitly).
		]"
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	CP_AGENT_TASK

inherit

	CP_DEFAULT_TASK

	CP_IMPORT_VALIDATOR

	REFACTORING_HELPER

create
	make_safe, make_unsafe, make_from_separate

feature {NONE} -- Initialization

	make_safe (a_routine: like routine)
			-- Initialize `Current' with `a_routine'.
			-- Check out the class header for restrictions on `a_routine'.
		require
			importable: is_agent_importable (a_routine)
			no_attributes: not is_defining_attributes (a_routine)
			no_open_arguents: not has_open_arguments (a_routine)
		do
			routine := a_routine
		end

	make_unsafe (a_routine: like routine)
			-- Initialize `Current' wiht `a_routine'.
			-- Note: This function is dangerous, as it may introduce traitors or Void calls.
			-- Make sure you follow these two rules:
			--- All closed arguments are either expanded or declared as separate.
			--- The agent must never access its target (i.e. no implicit or explicit use of Current).
		require
			unsafe_importable: is_agent_unsafe_importable (a_routine)
			no_open_arguents: not has_open_arguments (a_routine)
		do
			routine := a_routine
		end

	make_from_separate (other: separate like Current)
			-- <Precursor>
		local
			importer: CP_AGENT_IMPORTER
		do
			is_unsafe := other.is_unsafe
			promise := other.promise

			create importer
			if is_unsafe then
				routine := importer.unsafe_import (other.routine)
			else
				routine := importer.import (other.routine)
			end
		end

feature -- Access

	routine: ROUTINE [ANY, TUPLE]
			-- The agent to run.

feature -- Status report

	is_unsafe: BOOLEAN
			-- Should an unsafe import be used?

feature -- Basic operations

	run
			-- <Precursor>
		local
			l_type_id: INTEGER
			l_reflector: REFLECTOR
			l_target: ANY
		do
			create l_reflector
				-- Get type of the routine.
			l_type_id := {ISE_RUNTIME}.dynamic_type (routine)
				-- Get the type of its target.
			l_type_id := l_reflector.generic_dynamic_type_of_type (l_type_id, 1)
				-- Create the target.
			l_target := l_reflector.new_instance_of (l_type_id)

			routine.call ([l_target])
		end

feature -- Contract support

	is_defining_attributes (a_routine: like routine): BOOLEAN
			-- Does the target of `a_routine' define attributes?
		local
			l_type_id: INTEGER
		do
				-- The type of the target should not define any attributes.
			l_type_id := {ISE_RUNTIME}.dynamic_type (a_routine)
			l_type_id := reflector.generic_dynamic_type_of_type (l_type_id, 1)
			Result := reflector.field_count_of_type (l_type_id) /= 0
		end

	has_open_arguments (a_routine: like routine): BOOLEAN
			-- Does `a_routine' have an open argument (except for a target)?
		do
			if a_routine.is_target_closed then
				Result := a_routine.open_count > 0
			else
				Result := a_routine.open_count > 1
			end
		end

end
