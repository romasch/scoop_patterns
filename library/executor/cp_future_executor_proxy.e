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

	put_future (a_computation: separate CP_COMPUTATION [G]): CP_RESULT_PROMISE_PROXY [G, IMPORTER]
			-- <Precursor>
		local
			l_template_broker: CP_SHARED_RESULT_PROMISE [G, IMPORTER]
			l_importable: separate CP_IMPORTABLE
			l_broker: separate CP_SHARED_RESULT_PROMISE [G, IMPORTER]
		do
				-- Create a broker on the global result processor.
			create l_template_broker.make
			l_importable := new_result_broker (result_broker_processor, l_template_broker)

				-- Check must succeed because we're importing based on the dynamic type.
			check attached {separate CP_SHARED_RESULT_PROMISE [G, IMPORTER]} l_importable as l_checked then
				l_broker := l_checked
			end

				-- Initialiye the computation and the result.
			a_computation.set_broker (l_broker)

			create Result.make (l_broker)

				-- Submit the work to the worker pool.
			put (a_computation)
		ensure
			same_broker: Result.subject = a_computation.broker
		end

end
