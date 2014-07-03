note
	description: "Shared broker objects that can import the result of a separate task."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	CP_RESULT_BROKER [G, IMPORTER -> CP_IMPORT_STRATEGY [G] create default_create end]

inherit
	CP_SHARED_BROKER
		redefine
			make
		end

	CP_IMPORTABLE

create
	make, make_from_separate

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			Precursor
			create importer
		end


	make_from_separate (a_object: separate like Current)
			-- <Precursor>
		do
			make
		end

feature -- Access

	item: detachable like importer.import
			-- The generated result.
			-- May be void in case of an exception.
		require
			terminated: is_terminated
		attribute
		end

feature -- Basic operations

	set_item (a_item: separate G)
			-- Set `item' to `a_item'.
		do
			item := importer.import (a_item)
		end

feature {NONE} -- Implementation

	importer: IMPORTER
			-- Importer object for results.

end
