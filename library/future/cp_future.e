note
	description: "Encapsulates a future result. May block if the result is not yet ready."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	CP_FUTURE [G, IMPORTER -> CP_IMPORT_STRATEGY [G] create default_create end]


create
	make

feature {NONE} -- Initialization

	make (a_cell: like result_cell)
			-- Initialization for `Current'.
		do
			create importer
			result_cell := a_cell
		end

feature -- Status report

	is_available: BOOLEAN
			-- Is the future result available?
		do
			Result := is_imported or else sep_is_available (result_cell)
		end

feature -- Access

	item: detachable like importer.import
			-- The result of the computation.
		do
			if not is_imported then
				sep_item (result_cell)
			end
			Result := imported_item
		end


feature {NONE} -- Implementation

	is_imported: BOOLEAN
			-- Is the future already imported into `Current'?

	result_cell: separate CP_RESULT_BROKER [G, IMPORTER]
			-- The separate result

	imported_item: detachable like importer.import

	importer: IMPORTER

feature {NONE} -- Implementation: SCOOP helpers.

	sep_is_available (a_res: like result_cell): BOOLEAN
			-- Check if the result is available.
		do
			Result := a_res.is_finished
		end

	sep_item (a_res: separate CP_RESULT_BROKER [G, IMPORTER])
			-- Get the separate result.
		require
			available: a_res.is_finished
		do
			if attached a_res.item as it then
				imported_item := importer.import (it)
				is_imported := True
			end
		end

end
