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
			l_template_promise: CP_SHARED_RESULT_PROMISE [G, IMPORTER]
			l_importable: separate CP_IMPORTABLE
			l_promise: separate CP_SHARED_RESULT_PROMISE [G, IMPORTER]
		do
				-- Create a promise on the global result processor.
			create l_template_promise.make
			l_importable := new_result_promise (result_promise_processor, l_template_promise)

				-- Check must succeed because we're importing based on the dynamic type.
			check attached {separate CP_SHARED_RESULT_PROMISE [G, IMPORTER]} l_importable as l_checked then
				l_promise := l_checked
			end

				-- Initialiye the computation and the result.
			a_computation.set_promise (l_promise)

			create Result.make (l_promise)

				-- Submit the work to the worker pool.
			put (a_computation)
		ensure
			same_promise: Result.subject = a_computation.promise
		end

end
