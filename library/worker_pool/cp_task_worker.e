note
	description: "Summary description for {CP_TASK_WORKER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CP_TASK_WORKER

inherit
	CP_WORKER [CP_TASK, CP_DYNAMIC_TYPE_IMPORTER [CP_TASK]]

create
	make

feature -- Basic operations

	do_work (a_item: CP_TASK)
			-- <Precursor>
		do
			a_item.run
		end

end
