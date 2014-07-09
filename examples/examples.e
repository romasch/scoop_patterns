note
	description : "Root class that runs all examples one by one."
	date        : "$Date$"
	revision    : "$Revision$"

class
	EXAMPLES

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			example_loader: detachable separate ANY
			compile_helper_1: APPLICATION
			compile_helper_2: CP_AGENT_IMPORTER
		do
			example_loader := create {PRODUCER_CONSUMER}.make
			example_loader := create {ECHO_APPLICATION}.make
			example_loader := create {IO_WORKER_POOL}.make
			example_loader := create {GAUSS_APPLICATION}.make
		end

end
