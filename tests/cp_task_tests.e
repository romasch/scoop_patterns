note
	description: "Summary description for {CP_TASK_TESTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CP_TASK_TESTS

inherit

	CP_STARTABLE_UTILS
		undefine
			default_create
		end

	EQA_TEST_SET
		redefine
			on_prepare, on_clean
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

	test_delayed_task
			-- Test a delayed task.
		local
			delayer: CP_DELAYED_TASK
			task: CANCELABLE_TEST
			broker: CP_BROKER_PROXY
		do
			create task
			create delayer.make (task, 2 * second)

			assert ("has_broker", not attached task.broker)

			broker := executor.put_with_broker (delayer)

			assert ("broker_missing", attached task.broker)
			assert ("different_broker", task.broker = delayer.broker and broker.broker = delayer.broker)

			broker.cancel
			assert ("not_cancelled", broker.is_cancelled)

			env.sleep (second)

			assert ("not_delayed", not broker.is_terminated)

			broker.await_termination

			assert ("not_terminated", broker.is_terminated)
			assert ("has_exception", not broker.is_exceptional)
		end

	test_timer
			-- Test a timer object.
		local
			task: separate TICK_TIMER
		do
			create task.make (second)
			async_start (task)

			env.sleep (5 * second)
			timer_stop (task)

			assert ("not_started", timer_count (task) > 0)
		end


feature {NONE} -- Initialization

	second: INTEGER_64 = 1_000_000_000

	on_prepare
			-- <Precursor>
		local
			sep_executor: separate CP_TASK_WORKER_POOL
		do
			create sep_executor.make (100, 4)
			create executor.make (sep_executor)
			create env
		end

	on_clean
			-- <Precursor>
		do
			executor.stop
		end

	executor: CP_EXECUTOR_PROXY
			-- A global worker pool.

	env: EXECUTION_ENVIRONMENT
			-- An execution environment to call `sleep' on.

	timer_stop (a_timer: separate CP_PERIODIC_PROCESS)
		do
			a_timer.stop
		end

	timer_count (a_timer: separate TICK_TIMER): INTEGER
		do
			Result := a_timer.count
		end

end
