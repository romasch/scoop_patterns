note
	description:
		"[
			A strategy that does not perform copies or import.
			
			This strategy should be used for expanded types or very
			large objects such as images.
			
			Note: Make sure that non-expanded objects are located on their
			own processor, if they are passed to components making use of 
			this import strategy. Otherwise a deadlock or unintentional 
			serialization may occur.
		]"
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	CPS_NO_IMPORT [G]

inherit
	CPS_IMPORT_STRATEGY [G]

feature

	import (object: separate G): separate G
			-- Don't import `object'.
		do
			Result := object
		ensure then
			Result = object
		end

end
