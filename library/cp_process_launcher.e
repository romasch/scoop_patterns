note
	description: "Helper class to start a separate CP_PROCESS."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	CP_PROCESS_LAUNCHER

feature -- Basic operations

	launch (a_process: separate CP_PROCESS)
			-- Start the separate `a_process' object.
		do
			a_process.start
		end

end
