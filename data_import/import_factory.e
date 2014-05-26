note
	description: "Summary description for {IMPORT_FACTORY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	IMPORT_FACTORY [DATA]

feature

	new_from_separate (obj: separate DATA): DATA
	-- api description would be nice to have.
		deferred
		end

end
