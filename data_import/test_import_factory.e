note
	description: "Summary description for {TEST_IMPORT_FACTORY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_IMPORT_FACTORY
-- this class works with strings. would be nice to have some other examples of data classes. Something like vectors, matrices,
-- byte buffers, custom objects (address).
-- does it have any connection with cloning?
inherit
	IMPORT_FACTORY [STRING]

feature

	new_from_separate (str: separate STRING): STRING
		do
			create Result.make_from_separate (str)
		end

end
