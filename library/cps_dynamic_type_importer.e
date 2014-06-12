note
	description:
	"[
		Import strategy: Copy objects to the local processor.
		
		Note: The dynamic type of the imported object will be 
		the same as with the original object. This is done
		using reflection.
		To make this safe, all descendants of G must satisfy 
		the following two rules:
		
		1) They cannot have invariants.
		
		2) Feature `make_from_separate' must be a creation
		   procedure in every non-deferred descendant of G.
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CPS_DYNAMIC_TYPE_IMPORTER[G -> CPS_IMPORTABLE]

inherit
	CPS_IMPORTER [G]

	REFLECTOR
		export {NONE}
			all
		end

feature

	import (a_object: separate G): G
			-- <Precursor>
		local
			l_type_id: INTEGER
			l_clone: detachable ANY
		do
				-- Get the type id.
			l_type_id := a_object.generating_type.type_id

				-- Create an uninitialized clone on the current processor.
			l_clone := new_instance_of (l_type_id)

				-- Downcast the new object.
			check attached {G} l_clone as l_result then
				Result := l_result
			end

				-- Initialize the result.
			Result.make_from_separate (a_object)
		end

end
