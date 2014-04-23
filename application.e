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
		do
			default_create
			create n
			test2 (n)
			print_separate (output)
			print ("%N")
		end

	test2 (n: separate APPLICATION)
		local
			s: separate STRING
			app: separate APPLICATION
			ag: separate ROUTINE [ANY, TUPLE]
			task: separate STRING_APPENDER
			task2: separate AGENT_TASK
		do
			create s.make_from_separate ("external")
			create task2.make (agent n.append (output, s))
--			create task.make (output, s)
--			create app
			append (output, "first")
			ag := agent n.append (output, s)
--			asynch (ag)
			asdf (task2)
			append (output, "third")
		end

	asdf (t: separate TASK)
		do
			t.run
		end

	append (str1, str2: separate STRING)
		do
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
		end

end
