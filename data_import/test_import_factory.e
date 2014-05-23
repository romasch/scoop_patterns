note
	description: "Summary description for {TEST_IMPORT_FACTORY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_IMPORT_FACTORY

inherit
	IMPORT_FACTORY [STRING]

feature

	new_from_separate (str: separate STRING): STRING
		do
			create Result.make_from_separate (str)
		end

end
