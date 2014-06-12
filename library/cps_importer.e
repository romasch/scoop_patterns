note
	description: "Import strategy: Copy separate objects to the local processor."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CPS_IMPORTER [G]

inherit
	CPS_IMPORT_STRATEGY [G]

feature

	import (object: separate G): G
			-- Copy `object' to the local processor.
		deferred
		end

end
