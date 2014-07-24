note
	description: "Processor-local access to a separate CP_RESULT_BROKER object."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	CP_RESULT_BROKER_PROXY [G, IMPORTER -> CP_IMPORT_STRATEGY [G] create default_create end]

inherit

	CP_RESULT_BROKER [G]

	CP_BROKER_PROXY
		redefine
			utils, broker
		end

create
	make

feature -- Access

	broker: separate CP_RESULT_BROKER [G]
			-- <Precursor>

	item: detachable like {IMPORTER}.import
			-- <Precursor>
			-- Blocks if the result is not yet available.
		require else
			True
		do
			if not is_imported then
				is_imported := True
				imported_item := utils.broker_imported_item (broker)
			end
			Result := imported_item
		end

feature {NONE} -- Implementation

	utils: CP_RESULT_BROKER_UTILS [G, IMPORTER]
			-- <Precursor>

	is_imported: BOOLEAN
			-- Is the future already imported into `Current'?

	imported_item: detachable like utils.importer.import
			-- The imported item.

end
