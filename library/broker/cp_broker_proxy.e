note
	description: "Processor-local proxy to a {separate CP_PROMISE} object."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	CP_PROMISE_PROXY

inherit
	CP_PROMISE

	CP_PROXY [CP_PROMISE, CP_PROMISE_UTILS]

create
	make

feature -- Access

	last_exception_trace: detachable READABLE_STRING_32
			-- The exception trace of the last exception.
		do
			Result := utils.promise_imported_last_exception_trace (subject)
		end

	progress: REAL
			-- <Precursor>
		do
			Result := utils.promise_progress (subject)
		end

feature -- Status report

	is_terminated: BOOLEAN
			-- Has the asynchronous operation terminated?
		do
			Result := utils.is_promise_terminated (subject)
		end

	is_exceptional: BOOLEAN
			-- Has there been an exception in the asynchronous call?
		do
			Result := utils.is_promise_exceptional (subject)
		end

	is_cancelled: BOOLEAN
			-- Has there been a cancellation request?
		do
			Result := utils.is_promise_cancelled (subject)
		end

feature -- Basic operations

	cancel
			-- Request a cancellation.
		do
			utils.promise_cancel (subject)
		end

	await_termination
			-- Wait until the task is terminated.
		do
			utils.promise_await_termination (subject)
		end

end
