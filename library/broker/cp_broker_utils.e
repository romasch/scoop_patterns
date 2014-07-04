note
	description: "Utility functions to access a separate CP_BROKER object."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	CP_BROKER_UTILS

feature -- Access

	broker_last_exception_trace (a_broker: separate CP_BROKER): detachable separate READABLE_STRING_32
			-- Last exception trace in `a_broker'.
		do
			Result := a_broker.last_exception_trace
		end

	broker_imported_last_exception_trace (a_broker: separate CP_BROKER): detachable READABLE_STRING_32
			-- Imported exception trace in `a_broker'.
		do
			if attached broker_last_exception_trace (a_broker) as l_trace then
				create {STRING_32} Result.make_from_separate (l_trace)
			end
		end

feature -- Status report

	is_broker_terminated (a_broker: separate CP_BROKER): BOOLEAN
			-- Is `a_broker' terminated?
		do
			Result := a_broker.is_terminated
		end

	is_broker_cancelled (a_broker: separate CP_BROKER): BOOLEAN
			-- Is `a_broker' cancelled?
		do
			Result := a_broker.is_terminated
		end

	is_broker_exceptional (a_broker: separate CP_BROKER): BOOLEAN
			-- Is `a_broker' exceptional?
		do
			Result := a_broker.is_terminated
		end

feature -- Basic operations

	broker_cancel (a_broker: separate CP_BROKER)
			-- Cancel `a_broker'.
		do
			a_broker.cancel
		end

	broker_terminate (a_broker: separate CP_SHARED_BROKER)
			-- Terminate `a_broker'.
		do
			a_broker.terminate
		end

	broker_set_exception (a_broker: separate CP_SHARED_BROKER; a_exception: separate EXCEPTION)
			-- Set `a_exception' in `a_broker'.
		do
			a_broker.set_exception (a_exception)
		end

feature -- Factory functions

	new_broker: CP_SHARED_BROKER
			-- Create a new broker on the local processor.
		do
			create Result.make
		end

end
