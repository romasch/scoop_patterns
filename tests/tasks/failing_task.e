note
	description: "Summary description for {FAILING_TASK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FAILING_TASK

inherit
	CP_TASK

create
	default_create, make_from_separate

feature

	run
			-- <Precursor>
		local
			l_exception: DEVELOPER_EXCEPTION
		do
			create l_exception
			l_exception.set_description ("failing_task_test")
			l_exception.raise
		end

	make_from_separate (other: separate like Current)
		do
			broker := other.broker
		end

end
