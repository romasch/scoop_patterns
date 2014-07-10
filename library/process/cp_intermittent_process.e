note
	description: "Active objects that allow other processors to access its data after each loop iteration."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CP_INTERMITTENT_PROCESS

inherit
	CP_PROCESS

	CP_LAUNCHER

feature -- Basic operations

	start
			-- Start the process.
		do
			setup
			launch (pacemaker)
		end

	iteration
			-- Do a single iteration of the loop body.
		 do
		 	step
		 	if is_stopped then
		 		finish
		 	else
		 		launch (pacemaker)
		 	end
		 end

feature {NONE} -- Implementation

	pacemaker: separate CP_PACEMAKER
			-- The pacemaker of `Current'.
		attribute
			create Result.make (agent iteration)
		end

end
