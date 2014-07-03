note
	description: "Interface for creating and starting a new future."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	CP_FUTURE_EXECUTOR_PROXY [G, IMPORTER -> CP_IMPORT_STRATEGY [G] create default_create end]

inherit

	CP_EXECUTOR_PROXY

create
	make, make_global

feature -- Basic operations

	put_future (a_computation: separate CP_COMPUTATION [G]): CP_RESULT_BROKER [G, IMPORTER]
			-- <Precursor>
		local
			l_template_broker: CP_SHARED_RESULT_BROKER [G, IMPORTER]
			l_importable: separate CP_IMPORTABLE
			l_broker: separate CP_SHARED_RESULT_BROKER [G, IMPORTER]
			l_result: CP_RESULT_BROKER_PROXY [G, IMPORTER]
		do
				-- Create a broker on the global result processor.
			create l_template_broker.make
			l_importable := new_result_broker (result_broker_processor, l_template_broker)

				-- Check must succeed because we're importing based on the dynamic type.
			check attached {separate CP_SHARED_RESULT_BROKER [G, IMPORTER]} l_importable as l_checked then
				l_broker := l_checked
			end

				-- Initialiye the computation and the result.
			a_computation.set_broker (l_broker)

			create l_result.make (l_broker)
			Result := l_result

				-- Submit the work to the worker pool.
			put (a_computation)
		end

feature {NONE} -- Initialization

	make_global
			-- Initialize `Current' with the global worker pool.
		local
			l_procs: CP_GLOBAL_PROCESSORS
		do
			create l_procs
			make (l_procs.global_worker_pool)
		end

end
