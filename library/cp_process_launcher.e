note
	description: "Helper class to start a separate CP_PROCESS."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	CP_LAUNCHER

feature -- Basic operations

	launch (a_launchable: separate CP_LAUNCHABLE)
			-- Start the separate `a_launchable' object.
		do
			a_launchable.start
		end

end
