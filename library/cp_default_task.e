note
	description: "A normal CP_TASK with a broker attribute."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CP_DEFAULT_TASK

inherit
	CP_TASK

feature -- Access

	broker: detachable separate CP_SHARED_PROMISE
			-- <Precursor>

feature -- Element change

	set_broker (a_broker: like broker)
			-- <Precursor>
		do
			broker := a_broker
		end
end
