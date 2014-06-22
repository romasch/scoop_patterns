note
	description: "Separate cell for a future result."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	CP_ASYNCH_RESULT [G, IMPORTER -> CP_IMPORT_STRATEGY [G] create default_create end]

inherit
	CP_ASYNCH_TOKEN
		redefine
			make
		end

create
	make, make_from_separate

feature {NONE} -- Initialization

	make
		do
			Precursor
			create importer
		end

feature -- Access

	item: detachable like importer.import

feature {CP_COMPUTATION} -- Basic operations

	set_item (a_item: separate G)
			-- Set `last_result' to `a_result'.
		do
			item := importer.import (a_item)
		end

feature {NONE} -- Implementation

	importer: IMPORTER

end
