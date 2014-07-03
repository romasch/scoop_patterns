note
	description: "Processor-local access to a separate CP_BROKER object."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	CP_BROKER_PROXY

inherit
	CP_BROKER

create
	make

feature {NONE} -- Initialization

	make (a_broker: like broker)
			-- Initialization for `Current'.
		do
			broker := a_broker
			create utils
		end

	utils: CP_BROKER_UTILS
			-- Utilitity functions to handle separate brokers.

feature -- Access

	broker: separate CP_BROKER
			-- The actual separate broker.

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

end
