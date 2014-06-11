note
	description: "Summary description for {TEST_FUTURE_TASK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_FUTURE_TASK

inherit
	FUTURE_TASK [separate STRING]

feature

	run
		local
			env: EXECUTION_ENVIRONMENT
			res: separate STRING
		do
			create env
			env.sleep (2 * 1000000000)
			create res.make_filled ('a', 10)
			set_result (token, res)
		end

	make_from_separate (a_task: separate like Current)
			-- Initialize `Current' from `a_task'.
		do
		end

end
