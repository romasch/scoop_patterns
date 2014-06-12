note
	description: "Defines if objects shall be copied across processor boundaries."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CPS_IMPORT_STRATEGY [G]

feature

	import (object: separate G): separate G
			-- Import `object' based on the strategy defined in `Current'.
		deferred
		end

end
