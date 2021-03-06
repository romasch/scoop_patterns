note
	description : "tests application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION

inherit
	CONCURRENCY redefine default_create end

create
	make, default_create, test_expanded

feature -- Initialization

	default_create do create output.make (100) end

	make
			-- Run application.
		local
			n: separate APPLICATION
			d: PUBLISHER [TUPLE]
			imp: separate TUPLE_IMPORTER_TESTS [TUPLE]
		do
			print ("%N%N<<<%N")
			default_create
			create n
--			test (n)
--			test2 (n)
--			print_separate (output)
--			test_future
--			test_timer (create {separate TEST_AGENTS})
--			test_worker_pool
--			test_blocking_agent (create {separate TEST_AGENTS})

--			create imp.test_importer

		--	test_future
		--	test_future_with_result
		--	test_blocking_future
--			test_importer
--			test_worker_pool_new

--			(create {AGENT_IMPORTER_TESTS}.make).do_nothing

			create n.test_expanded
			print ("%N>>>%N%N")
		end

	test_lock_passing (obj: detachable separate ANY)
		do
				-- obj not locked
			if attached obj as l_obj then

					-- l_obj should not be controlled.
				--l_obj.print (1)

					-- Why is obj controlled?
				obj.print (1)
			end
		end

	test_worker_pool
		local
			factory: separate TEST_WORKER_FACTORY
			pool: separate WORKER_POOL [STRING]
			env: EXECUTION_ENVIRONMENT
		do
			create factory
			create pool.make (factory)
			internal_test_worker_pool (pool)
			create env
			env.sleep (1000000000)
			close_pool (pool)
		end

	internal_test_worker_pool (pool: separate WORKER_POOL [STRING])
		do
			pool.enlarge (2)
			pool.submit (create {separate STRING}.make_from_separate ("asdf"))
			pool.submit (create {separate STRING}.make_from_separate ("jklo"))
			pool.submit (create {separate STRING}.make_from_separate ("qwert"))
			pool.submit (create {separate STRING}.make_from_separate ("1234"))
		end

	close_pool (pool: separate WORKER_POOL [STRING]) do pool.close end

	test_future
		local
			task: separate TEST_FUTURE_TASK
			my_future: separate FUTURE [separate ANY]
			env: EXECUTION_ENVIRONMENT
		do
			create task
			my_future := future (task)

			from
				create env
			until
				is_available (my_future)
			loop
				print ("not_available%N")
				env.sleep (1000000000)
			end

			print_separate (get_result (my_future))

		end

	test_future_with_result
	-- the same as `test_future', but features a wrapper object, `FUTURE_RESULT',
	-- so that a client does not need to write wrapper methods.
	-- However, `FUTURE_RESULT' is an expanded type and cannot be passed to a method.
	-- instead, the future itself should be used in that case.
		local
			task: separate TEST_FUTURE_TASK
			my_future: separate FUTURE [separate ANY]
			env: EXECUTION_ENVIRONMENT
			l_future_result : FUTURE_RESULT[separate ANY]
		do
			create task
			my_future := future (task)
			create l_future_result.from_future (my_future)

			from
				create env
			until
				l_future_result.is_available
			loop
				print ("not_available%N")
				env.sleep (1000000000)
			end

			print_separate (l_future_result.item)
		end

	test_future_of_future
	do

	end

	test_blocking_future
		local
			task: separate TEST_FUTURE_TASK
			l_future_result : FUTURE_RESULT[separate ANY]
		do
			create task
			create l_future_result.from_future (future (task))
			-- here, current processor should block until the item is available.
			print_separate (l_future_result.item)
		end

	test_timer (ag: separate TEST_AGENTS)
		local
			task: separate AGENT_TASK
			timer: separate TIMER
		do
			create task.put (agent ag.timer_tick)
			timer := new_timer (task, 1000)
			start_timer (timer)
		end

	start_timer (timer: separate TIMER)
		do
			timer.start
		end

	is_available (a_future: separate FUTURE [separate ANY]): BOOLEAN
		do
			Result := a_future.is_available
		end

	get_result (a_future: separate FUTURE [separate ANY]): separate ANY
		do
			Result := a_future.item
		end

	test2 (n: separate APPLICATION)
		local
			s: separate STRING
			app: separate APPLICATION
			ag: separate ROUTINE [ANY, TUPLE]
			task: separate STRING_APPENDER
			task2, task3: separate AGENT_TASK
		do
			create s.make_from_separate ("external")
--			create task2.make (agent n.append (output, s))
--			create task3.make (agent n.print_separate (output))
--			create task.make (output, s)
--			create app
			append (output, "first")
			asynch_unordered (agent n.append (output, s), 10000)
			asynch_unordered (agent n.print_separate (output), 10000)
--			asdf (task2)
			append (output, "third")
--			print_separate(output)
		end

	asdf (t: separate TASK)
		do
			t.run
		end

	append (str1, str2: separate STRING)
		do
--			if str2 [1] = 'e' then
--				across 1 |..| 100000 as thrash loop do_nothing end
--			end

			across 1 |..| str2.count as i loop
				str1.extend (str2[i.item])
			end
		end

	output: separate STRING

	test (n: separate APPLICATION)
		local
			ag:separate PROCEDURE [ANY, TUPLE]
			str: separate STRING
			i: separate INTEGER_REF
		do
			io.new_line
			create i
			create str.make_from_separate ("blub")
			ag := agent n.print_separate (str)
			n.print_separate (create {ANY})
--			call (ag)
			call (agent n.print_separate ("asdf%N"))
--			print (ag)
			print (3)
			io.new_line
		end

	print_separate (str: detachable separate ANY)
		local
			s: STRING
		do
			if str /= Void then
				create s.make_from_separate (str.out)
				print (s)
			end
			print ("%N")
		end

	test_blocking_agent (obj: separate TEST_AGENTS)
		do
			call (agent obj.delayed_print)
			print ("non_delayed_nessage%N")

			call (agent obj.delayed_print_with_arg (create {separate STRING}.make_filled (' ', 10)))
			print ("non_delayed_nessage_2%N")

			call (agent obj.delayed_print_with_arg ("a_local_dependency"))
			print ("non_delayed_nessage_3%N")
		end


	test_importer
		local
			factory: separate TEST_WORKER_FACTORY
			pool: separate IMPORTING_WORKER_POOL [STRING, TEST_IMPORT_FACTORY]
			acc: WORKER_POOL_ACCESS [STRING]
			env: EXECUTION_ENVIRONMENT
			i: INTEGER
		do
			create factory
			create pool.make (factory)
			create acc

			create env
			from
				acc.submit (pool, "a")
				acc.submit (pool, "b")
				acc.submit (pool, "c")
				acc.submit (pool, "d")
				acc.submit (pool, "e")
				init_pool (pool)
				i := 1
			until
				i > 1000
			loop
--				env.sleep (1000000000)
				acc.submit (pool, "1")
--				submit_data (pool)
				i := i + 1
			end

			env.sleep (1000000000)
			close_pool (pool)
		end

	init_pool (pool: separate WORKER_POOL [STRING])
		do
			pool.enlarge (2)
		end

	submit_data (pool: separate WORKER_POOL [STRING])
		do
			pool.submit ("1")
--			pool.submit ("2")
--			pool.submit ("3")
--			pool.submit ("4")
--			pool.submit ("5")
		end

feature -- new worker pool

	test_worker_pool_new
		local
			factory: separate TEST_WORKER_FACTORY_NEW
			pool: separate WORKER_POOL_NEW [STRING, TEST_IMPORT_FACTORY]
			env: EXECUTION_ENVIRONMENT
		do
			create factory
			create pool.make (factory)
			internal_test_worker_pool_new (pool)
			create env
			env.sleep (1000000000)
			close_pool_new (pool)
		end

	internal_test_worker_pool_new (pool: separate WORKER_POOL_NEW [STRING, TEST_IMPORT_FACTORY])
		do
			pool.enlarge (2)
			pool.submit ( ("asdf"))
			pool.submit ( ("jklo"))
			pool.submit ( ("qwer"))
			pool.submit ( ("1234"))
		end

	close_pool_new (pool: separate WORKER_POOL_NEW [STRING, TEST_IMPORT_FACTORY]) do pool.close end

	test_expanded
			-- This simple test creates a traitor...
		local
			cell: separate CELL [separate ANY]
			etest: ETEST
			any: ANY
		do
			default_create
			any := etest
			create cell.put (any)
		end

end
