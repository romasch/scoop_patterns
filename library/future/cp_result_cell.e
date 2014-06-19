note
	description: "Separate cell for a future result."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	CP_RESULT_CELL [G, IMPORTER -> CP_IMPORT_STRATEGY [G] create default_create end]

inherit
	CP_IMPORTABLE

create
	make, make_from_separate

feature {NONE} -- Initialization

	make
		do
			create importer
			is_available := False
		end

feature -- Initialization

	make_from_separate (other: separate like Current)
			-- Initialize `Current' with the same values as `other'.
		do
			make
		end

feature -- Access

	item: detachable like importer.import

feature -- Status report

	is_available: BOOLEAN

feature {CP_COMPUTATION} -- Basic operations

	set_item (a_item: separate G)
			-- Set `last_result' to `a_result'.
		do
			item := importer.import (a_item)
			is_available := True
		end

feature {NONE} -- Implementation

	importer: IMPORTER

end
