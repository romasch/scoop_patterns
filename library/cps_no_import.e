note
	description: "A strategy that does not perform copies or import."
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
