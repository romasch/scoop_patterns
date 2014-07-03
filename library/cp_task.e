note
	description: "Operations that can be copied across processor boundaries."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CP_TASK

inherit

	CP_LAUNCHABLE

	CP_IMPORTABLE

	CP_BROKER_UTILS

feature -- Access

	broker: detachable separate CP_BROKER
			-- A stable communication object.

feature -- Basic operations

	set_broker (a_broker: like broker)
			-- Set `broker' to `a_broker'.
		do
			broker := a_broker
		end

	start
			-- Start the current task.
		local
			l_retried: BOOLEAN
			l_exception_manager: EXCEPTION_MANAGER
		do
			if not l_retried then
				run
				if attached broker as l_broker then
					broker_terminate (l_broker)
				end
			end
		rescue
			l_retried := True
			create l_exception_manager

			if
				attached l_exception_manager.last_exception as l_exception
				and	attached broker as l_broker
			then
				broker_set_exception (l_broker, l_exception)
				broker_terminate (l_broker)
			end

			retry
		end

	run
			-- Run the current task.
		deferred
		end

feature -- Initialization

	make_from_separate (other: separate like Current)
			-- Initialize `Current' from `other'.
		deferred
		ensure then
			same_token: broker = other.broker
		end

end
