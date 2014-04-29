note
	description: "Summary description for {TEST_WORKER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_WORKER

inherit
	WORKER [STRING]

create make

feature

	do_work (s_str: separate STRING)
		local
			l_str: STRING
		do
			create l_str.make_from_separate (s_str)
			print (l_str)
		end

end
