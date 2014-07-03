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

	broker_item (a_broker: separate CP_RESULT_BROKER [G, IMPORTER]): detachable separate G
			-- Item in `a_broker'.
		require
			available: a_broker.is_terminated
		do
			Result := a_broker.item
		end

	broker_imported_item (a_broker: separate CP_RESULT_BROKER [G, IMPORTER]): detachable like importer.import
			-- Imported item in `a_broker'.
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

feature -- Factory functions

	new_independent_result_broker: separate CP_SHARED_RESULT_BROKER [G, IMPORTER]
			-- Create a new result broker object on a new processor.
		do
			create Result.make
		end

	new_result_broker: separate CP_SHARED_RESULT_BROKER [G, IMPORTER]
			-- Create a new result broker on the global broker processor.
		local
			l_broker: CP_SHARED_RESULT_BROKER [G, IMPORTER]
			l_importable: separate CP_IMPORTABLE
		do
			create l_broker.make
			l_importable := export_to_global_processor (global_broker_processor, l_broker)

				-- Check must succeed because we're importing based on the dynamic type.
			check attached {separate CP_SHARED_RESULT_BROKER [G, IMPORTER]} l_importable as l_result then
				Result := l_result
			end
		end

feature {NONE} -- Implementation

	export_to_global_processor (a_processor: separate CP_BROKER_PROCESSOR; a_broker: CP_IMPORTABLE): separate CP_IMPORTABLE
			-- Ask `a_processor' to import `a_broker'.
		do
			Result := a_processor.import (a_broker)
		end

	importer: IMPORTER
			-- Importer object for results.
		attribute
			create Result
		end

end
