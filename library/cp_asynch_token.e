note
	description: "Shared broker objects which can be used for communication between two processors."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	CP_BROKER

create
	make

feature -- Initialization

	make
			-- Initialization for `Current'.
		do
			is_finished := False
			is_exceptional := False
		end


feature -- Access

--	last_exception: detachable EXCEPTION
--			-- The last exception in the asynchronous call, if any.

feature -- Status report

	is_finished: BOOLEAN
			-- Has the asynchronous operation finished?

	is_exceptional: BOOLEAN
			-- Has there been an exception in the asynchronous call?

feature -- Basic operations

	finish
			-- Mark the asynchronous as finished.
		do
			is_finished := True
		end

	set_exception (a_exception: separate EXCEPTION)
			-- Set `last_exception' to `a_exception'.
		do
			-- TODO: Import an exception
			is_exceptional := True
		end

end
