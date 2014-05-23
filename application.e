note
	description : "tests application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION

inherit
	CONCURRENCY redefine default_create end

create
	make, default_create

feature -- Initialization

	default_create do create output.make (100) end

	make
			-- Run application.
		local
			n: separate APPLICATION
			d: PUBLISHER [TUPLE]
			imp: TUPLE_IMPORTER [TUPLE]
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

--			create imp
--			imp.test_importer

--			test_importer
			test_worker_pool_new
			print ("%N>>>%N%N")
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
			env: EXECUTION_ENVIRONMENT
			i: INTEGER
		do
			create factory
			create pool.make (factory)

			create env
			from
				init_pool (pool)
				i := 1
			until
				i > 100
			loop
--				env.sleep (1000000000)
				submit_data (pool)
				i := i + 1
			end

			env.sleep (1000000000)
			close_pool (pool)
		end

	init_pool (pool: separate WORKER_POOL [STRING])
		do
				-- Initial data
			pool.submit ("a")
			pool.submit ("b")
			pool.submit ("c")
			pool.submit ("d")
			pool.submit ("e")
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

end
