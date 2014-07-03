note
	description: "Summary description for {CP_FUTURE_TESTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CP_FUTURE_TESTS

inherit
	EQA_TEST_SET

	CP_GLOBAL_PROCESSORS
		undefine
			default_create
		end

feature

	test_fibonacci
		local
			l_computation: FIBONACCI_COMPUTATION
			l_future: CP_FUTURE [INTEGER, CP_NO_IMPORT [INTEGER]]
			l_starter: CP_FUTURE_STARTER [INTEGER, CP_NO_IMPORT [INTEGER]]
		do
			create l_starter
			create l_computation.make (6)
			l_future := l_starter.new_future (l_computation)

			assert ("wrong_result", l_future.item = 8)
		end

	test_fibonacci_executor
		local
			l_computation: FIBONACCI_COMPUTATION
			l_starter: CP_FUTURE_EXECUTOR_PROXY [INTEGER, CP_NO_IMPORT [INTEGER]]
			l_future: CP_RESULT_BROKER [INTEGER, CP_NO_IMPORT [INTEGER]]
		do
			create l_starter.make (global_worker_pool)
			create l_computation.make (6)

			l_future := l_starter.put_future (l_computation)

			assert ("wrong_result", l_future.item = 8)
		end

end
