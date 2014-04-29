note
	description: "Summary description for {TEST_AGENTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_AGENTS

feature

	timer_tick
		do
			print ("timer_tick%N")
		end

	delayed_print
		local
			env: EXECUTION_ENVIRONMENT
		do
			create env
			env.sleep (2 * 1000000000)
			print ("delayed_message%N")
		end

	delayed_print_with_arg (str: separate STRING)
		local
			env: EXECUTION_ENVIRONMENT
		do
			create env
			env.sleep (2 * 1000000000)
			print ("delayed_message:count=" + str.count.out + "%N")
		end

end
