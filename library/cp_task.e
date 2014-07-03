note
	description: "Operations that can be copied across processor boundaries."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CP_TASK

inherit
	CP_IMPORTABLE

feature -- Access

	asynch_token: detachable separate CP_BROKER
			-- A stable communication object.

feature -- Basic operations

	set_asynch_token (a_token: like asynch_token)
			-- Set `asynch_token' to `a_token'.
		do
			asynch_token := a_token
		end

	start
			-- Start the current task.
		local
			l_retried: BOOLEAN
			l_exception_manager: EXCEPTION_MANAGER
		do
			if not l_retried then
				run
				if attached asynch_token as l_token then
					token_finish (l_token)
				end
			end
		rescue
			l_retried := True
			create l_exception_manager

			if
				attached l_exception_manager.last_exception as l_exception
				and	attached asynch_token as l_token
			then
				token_set_exception (l_token, l_exception)
				token_finish (l_token)
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
			same_token: asynch_token = other.asynch_token
		end

feature {NONE} -- Implementation

	token_finish (a_token: attached like asynch_token)
			-- Call `a_token.finish'.
		do
			a_token.finish
		end

	token_set_exception (a_token: attached like asynch_token; a_exception: EXCEPTION)
			-- Call `a_token.set_exception (a_exception)'.
		do
			a_token.set_exception (a_exception)
		end

end
