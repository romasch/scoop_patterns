note
	description: "A set of processors containing a global pool of objects."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	CP_GLOBAL_PROCESSORS

feature -- Constants

	worker_count: INTEGER = 4
			-- Initial worker count for the global worker pool.
			-- TODO: Discuss a reasonable default.

	buffer_size: INTEGER = -1
			-- Buffer size for the global worker pool.
			-- A negative number corresponds to an unbounded pool.

feature -- Access

	broker_processor: separate CP_BROKER_PROCESSOR
			-- A processor for broker objects.
		once ("PROCESS")
			create Result
		end

	result_broker_processor: separate CP_DYNAMIC_TYPE_IMPORTER [CP_IMPORTABLE]
			-- A processor for result broker objects.
			-- New objects on this processor are created by importing an existing object.
		once ("PROCESS")
			create Result
		end

	global_worker_pool: separate CP_TASK_WORKER_POOL
			-- A global worker pool which can be used to execute futures.
		once ("PROCESS")
			create Result.make (buffer_size, worker_count)
		end

feature -- Utilities

	new_broker (a_processor: like broker_processor): separate CP_SHARED_BROKER
			-- Create a new broker on `a_processor'.
		do
			Result := a_processor.new_broker
		end

	new_result_broker (a_processor: like result_broker_processor; a_blueprint: CP_IMPORTABLE): separate CP_IMPORTABLE
			-- Export `a_blueprint' to `a_processor'.
		do
			Result := a_processor.import (a_blueprint)
		end

end
