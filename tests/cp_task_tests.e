note
	description: "Summary description for {CP_TASK_TESTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CP_TASK_TESTS

inherit

	EQA_TEST_SET
		redefine
			on_prepare
		end

feature -- Tests

	test_cancel
			-- Test if it is possible to cancel a task.
		local
			task: CANCELABLE_TEST
			broker: CP_BROKER_PROXY
		do
			create task
			assert ("has_broker", not attached task.broker)


			broker := executor.put_with_broker (task)

			assert ("different_broker", task.broker = broker.broker)

			assert ("not_running", not broker.is_terminated)
			assert ("cancelled", not broker.is_cancelled)
			assert ("has_exception", not broker.is_exceptional)

			broker.cancel

			assert ("not_cancelled", broker.is_cancelled)

			broker.await_termination

			assert ("not_cancelled", broker.is_cancelled)
			assert ("not_terminated", broker.is_terminated)
			assert ("has_exception", not broker.is_exceptional)
		end

	test_failing
			-- Test if a failing task doesn't break the executor.
		local
			failure: FAILING_TASK
			broker: CP_BROKER_PROXY
		do
			create failure
			assert ("has_broker", not attached failure.broker)

			broker := executor.put_with_broker (failure)

			assert ("different_broker", failure.broker = broker.broker)

			broker.await_termination

			assert ("no_exception", broker.is_exceptional)
			assert ("trace_not_available", attached broker.last_exception_trace)

			assert ("executor_count_wrong", executor.worker_count = {CP_GLOBAL_PROCESSORS}.worker_count)
		end

feature {NONE} -- Initialization

	on_prepare
			-- <Precursor>
		local
			l_global: CP_GLOBAL_PROCESSORS
		do
			create l_global
			create executor.make (l_global.global_worker_pool)
		end

	executor: CP_EXECUTOR_PROXY
			-- A global worker pool.

end
