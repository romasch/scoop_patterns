note
	description: "Interface for creating and starting a new future."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	CP_FUTURE_STARTER [G, IMPORTER -> CP_IMPORT_STRATEGY [G] create default_create end]

feature

	new_future (a_computation: CP_COMPUTATION [G]): CP_FUTURE [G, IMPORTER]
			-- Compute `a_computation' asynchronously.
			-- The result can later be retrieved in {CP_FUTURE}.item.
		local
			l_cell: separate CP_ASYNCH_RESULT [G, IMPORTER]
		do
			l_cell := new_cell_on_pool (result_pool)
			create Result.make (l_cell)

			a_computation.set_asynch_token (l_cell)
			worker_pool_proxy.submit (a_computation)
		end


feature {NONE} -- Data structures


	result_pool: separate CP_DYNAMIC_TYPE_IMPORTER [CP_IMPORTABLE]
			-- A single SCOOP processor taking care of all future result cells.
		once ("PROCESS")
			create Result
		end

	worker_pool: separate CP_TASK_WORKER_POOL
		once ("PROCESS")
				-- TODO: better defaults.
			create Result.make (20, 4)
		end

	worker_pool_proxy: CP_WORKER_POOL_PROXY [CP_TASK]
		once ("THREAD")
			create Result.make (worker_pool)
		end

feature {NONE} -- Result cell factory

	new_cell_on_pool (a_pool: like result_pool): separate CP_ASYNCH_RESULT [G, IMPORTER]
		local
			l_cell: CP_ASYNCH_RESULT [G, IMPORTER]
			l_importable: separate CP_IMPORTABLE
		do
			create l_cell.make
			l_importable := a_pool.import (l_cell)

				-- Check should succeed because we're using the dynamic type importer.
			check attached {separate CP_ASYNCH_RESULT [G, IMPORTER]} l_importable as l_result then
				Result := l_result
			end
		end

end
