note
	description: "Summary description for {TEST_WORKER_NEW}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_WORKER_NEW

inherit
	WORKER_NEW [STRING, TEST_IMPORT_FACTORY]

create
	make

feature

	do_work (str: STRING)
		local
			env: EXECUTION_ENVIRONMENT
		do
			create env
--			env.sleep (2000000000)
			print (str)
		end

end
