note
	description: "Shared broker objects that can import the result of a separate task."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CP_RESULT_BROKER [G, IMPORTER -> CP_IMPORT_STRATEGY [G] create default_create end]

inherit
	CP_BROKER

feature -- Access

	item: detachable like {IMPORTER}.import
			-- The generated result.
			-- May be void in case of an exception.
		require
			terminated: is_terminated
		deferred
		end

end
