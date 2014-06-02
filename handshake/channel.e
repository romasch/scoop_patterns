note
	description: "Summary description for {CHANNEL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CHANNEL [DATA, IMPORTER -> IMPORT_FACTORY [DATA] create default_create end]

feature

	imp: IMPORTER
		attribute create Result end

	data_available: BOOLEAN
		do
			Result := attached data
		end

	data: detachable DATA


	put_data (a_data: attached separate DATA)
		do
			data := imp.new_from_separate (a_data)
		end

	erase_data
		local
			l_void: detachable DATA
		do
			data := l_void
		end

end
