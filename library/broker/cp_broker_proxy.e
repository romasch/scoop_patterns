note
	description: "Processor-local access to a separate CP_BROKER object."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	CP_BROKER_PROXY

inherit
	CP_BROKER

	CP_PROXY [CP_BROKER, CP_BROKER_UTILS]
		rename
			subject as broker
		end

create
	make

feature -- Access

	last_exception_trace: detachable READABLE_STRING_32
			-- The exception trace of the last exception.
		do
			Result := utils.broker_imported_last_exception_trace (broker)
		end

feature -- Status report

	is_terminated: BOOLEAN
			-- Has the asynchronous operation terminated?
		do
			Result := utils.is_broker_terminated (broker)
		end

	is_exceptional: BOOLEAN
			-- Has there been an exception in the asynchronous call?
		do
			Result := utils.is_broker_exceptional (broker)
		end

	is_cancelled: BOOLEAN
			-- Has there been a cancellation request?
		do
			Result := utils.is_broker_cancelled (broker)
		end

feature -- Basic operations

	cancel
			-- Request a cancellation.
		do
			utils.broker_cancel (broker)
		end

	await_termination
			-- Wait until the task is terminated.
		do
			utils.broker_await_termination (broker)
		end

end
