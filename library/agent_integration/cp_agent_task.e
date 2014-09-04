note
	description: "[
		Task object that execute an agent. 
		
		Note: The agent will be moved across processor boundaries via reflection and thus
		has to fulfill some requirements:
		
		1)  Every closed argument has to be either truly separate or a basic
			expanded type. It is NOT sufficient to just declare the argument 
			as separate, as this cannot	be checked due to a runtime limitation.
			
		2)  The target must be open. It will be reflectively created after the import.
		
		3)  The type of the target must not declare any attributes.
		
		4)  There must not be any leftovers from a previous call, 
			i.e. `operands' and {FUNCTION}.last_result must be Void.
		
		The creation procedure `make_unsafe' does not check 
		rules 1) and 3). If you use it, make sure that every closed
		argument is declared as	separate, and that the agent never 
		accesses an attribute in `Current' (implicitly or explicitly).
		]"
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	CP_AGENT_TASK

inherit

	CP_DEFAULT_TASK

	REFACTORING_HELPER

create
	make_safe, make_unsafe, make_from_separate

feature {NONE} -- Initialization

	make_safe (a_routine: like routine)
			-- Initialize `Current' with `a_routine'.
			-- Check out the class header for restrictions on `a_routine'.
		require
			importable: (create {CP_AGENT_IMPORTER}).is_importable (a_routine)
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
			open_target: (create {CP_AGENT_IMPORTER}).is_unsafe_importable (a_routine)
			no_open_args: to_implement_assertion ("TODO")
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

end
