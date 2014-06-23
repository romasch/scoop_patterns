note
	description: "Summary description for {CP_CONTINUOUS_PROCESS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CP_CONTINUOUS_PROCESS

inherit
	CP_PROCESS

feature -- Basic operations

	start
			-- Start the current process.
		do
			from
				setup
			until
				is_stopped
			loop
				step
			end
			finish
		end

end
