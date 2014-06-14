note
	description: "Summary description for {CPS_STRING_IMPORTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CPS_STRING_IMPORTER

inherit
	CPS_IMPORTER [STRING]

feature

	import (object: separate STRING): STRING
			-- <Precursor>
		do
			create Result.make_from_separate (object)
		end

end
