note
	description: "Interface for broker objects which can be used for communication between two processors."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CP_BROKER

feature -- Access

--	last_exception: detachable EXCEPTION
--			-- The last exception in the asynchronous call, if any.

	last_exception_trace: detachable READABLE_STRING_32
			-- The exception trace of the last exception.
		deferred
		end

feature -- Status report

	is_terminated: BOOLEAN
			-- Has the asynchronous operation terminated?
		deferred
		end


	is_successfully_terminated: BOOLEAN
			-- Has the asynchronous operation terminated without an exception?
		do
			Result := is_terminated and then not is_exceptional
		end


	is_exceptional: BOOLEAN
			-- Has there been an exception in the asynchronous call?
		deferred
		end

	is_cancelled: BOOLEAN
			-- Has there been a cancellation request?
		deferred
		end

feature -- Basic operations

	cancel
			-- Request a cancellation.
		deferred
		ensure
			cancelled: is_cancelled
		end

invariant
	trace_implies_exceptional: attached last_exception_trace implies is_exceptional
	exception_implies_terminated: is_exceptional implies is_terminated
end
