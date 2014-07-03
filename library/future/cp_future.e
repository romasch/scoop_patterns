note
	description: "Encapsulates a future result. May block if the result is not yet ready."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	CP_FUTURE [G, IMPORTER -> CP_IMPORT_STRATEGY [G] create default_create end]

--create
--	make

--feature {NONE} -- Initialization

--	make (a_cell: like broker)
--			-- Initialization for `Current'.
--		do
--			create utils
--			broker := a_cell
--		end

--feature -- Status report

--	is_available: BOOLEAN
--			-- Is the future result available?
--		do
--			Result := is_imported or else utils.is_broker_terminated (broker)
--		end

--feature -- Access

--	item: detachable like utils.importer.import
--			-- The result of the computation.
--			-- Blocks if the result is not yet available.
--			-- May be void in case of an exception.
--		do
--			if not is_imported then
--				is_imported := True
--				imported_item := utils.broker_imported_item (broker)
--			end
--			Result := imported_item
--		end

--feature {NONE} -- Implementation

--	broker: separate CP_RESULT_BROKER [G, IMPORTER]
--			-- The broker object that stores the separate result.

--	utils: CP_RESULT_BROKER_UTILS [G, IMPORTER]
--			-- Utilities to access the broker.

--	is_imported: BOOLEAN
--			-- Is the future already imported into `Current'?

--	imported_item: detachable like utils.importer.import
--			-- The imported item.

end
