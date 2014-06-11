note
	description: "Summary description for {STRING_APPENDER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STRING_APPENDER

inherit
	TASK

create
	make, make_from_separate

feature -- Access

	target: separate STRING

	appendix: separate STRING

feature

	run
		do
--			across 1 |..| 1000000 as i loop do_nothing end
			controlled_run (target, appendix)
		end

	controlled_run (tar, app: separate STRING)
		do
			across 1 |..| app.count as idx loop
				tar.extend (app [idx.item])
			end
		end

	make_from_separate (a_task: separate like Current)
			-- Initialize `Current' from `a_task'.
		do
			target := a_task.target
			appendix := a_task.appendix
		end

feature {NONE} -- Initialization

	make (tar, app: separate STRING)
			-- Initialization for `Current'.
		do
			target := tar
			appendix := app
		end



end
