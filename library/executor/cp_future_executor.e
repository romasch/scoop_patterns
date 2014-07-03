note
	description: "Executor service to run CP_COMPUTATION objects asynchronously."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CP_FUTURE_EXECUTOR [G, IMPORTER -> CP_IMPORT_STRATEGY [G] create default_create end]

--inherit
--	CP_EXECUTOR

--feature -- Basic operations

--	put_future (a_computation: separate CP_COMPUTATION [G]): separate CP_RESULT_BROKER [G, IMPORTER]
--			-- Execute `a_computation' asynchronously and return a result broker object.
--		deferred
--		end

end
