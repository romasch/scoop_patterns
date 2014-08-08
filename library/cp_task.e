note
	description: "Operations that can be copied across processor boundaries."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CP_TASK

inherit

	CP_STARTABLE

	CP_IMPORTABLE

	CP_PROMISE_UTILS

feature {CP_DYNAMIC_TYPE_IMPORTER}-- Initialization

	make_from_separate (other: separate like Current)
			-- Initialize `Current' from `other'.
		deferred
		ensure then
			same_token: broker = other.broker
		end

feature -- Access

	broker: detachable separate CP_SHARED_PROMISE
			-- A stable communication object.
		deferred
		end

feature -- Element change

	set_broker (a_broker: like broker)
			-- Set `broker' to `a_broker'.
		deferred
		ensure
			promise_set: broker = a_broker
		end

feature -- Basic operations

	frozen start
			-- Start the current task.
		local
			l_retried: BOOLEAN
			l_exception_manager: EXCEPTION_MANAGER
		do
			if not l_retried then
				run
				if attached broker as l_broker then
					promise_terminate (l_broker)
				end
			end
		rescue
			l_retried := True
			create l_exception_manager

			if
				attached l_exception_manager.last_exception as l_exception
				and	attached broker as l_broker
			then
				promise_set_exception_and_terminate (l_broker, l_exception)
			end

			retry
		end

	run
			-- Run the current task.
		deferred
		end

end
