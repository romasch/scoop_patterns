note
	description: "Summary description for {DATA_CELL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DATA_CELL [DATA, IMPORTER -> IMPORT_FACTORY [DATA] create default_create end]

create
	make

feature

	make
		do create importer end 

	importer: IMPORTER
		attribute create Result end

	item: detachable DATA

	set_item (an_item: detachable separate DATA)
		local
			l_void: detachable DATA -- strange compile error...
		do
			if attached an_item then
				item := importer.new_from_separate (an_item)
			else
				item := l_void
			end
		end



end
