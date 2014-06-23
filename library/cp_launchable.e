note
	description: "Objects that define an operation which may be invoked asynchronously."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CP_LAUNCHABLE

feature -- Basic operations

	start
			-- Launch the operation defined in `Current'.
		deferred
		end

end
