note
	description: "Utility functions to access a separate CP_RESULT_BROKER object."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	CP_RESULT_BROKER_UTILS [G, IMPORTER -> CP_IMPORT_STRATEGY [G] create default_create end]

inherit
	CP_BROKER_UTILS

feature -- Access

	broker_item (a_broker: separate CP_RESULT_BROKER [G]): detachable separate G
			-- Item in `a_broker'.
		require
			available: a_broker.is_terminated
		do
			Result := a_broker.item
		end

	broker_imported_item (a_broker: separate CP_RESULT_BROKER [G]): detachable like importer.import
			-- Imported item in `a_broker'.
		require
			available: a_broker.is_terminated
		do
			if attached a_broker.item as l_item then
				Result := importer.import (l_item)
			end
		end

feature -- Basic operations

	broker_set_item (a_broker: separate CP_SHARED_RESULT_BROKER [G, IMPORTER]; a_item: separate G)
			-- Set `a_item' in `a_broker'.
		do
			a_broker.set_item (a_item)
		end

feature {NONE} -- Implementation

	importer: IMPORTER
			-- Importer object for results.
		attribute
			create Result
		end

end
