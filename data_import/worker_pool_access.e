note
	description: "Summary description for {WORKER_POOL_ACCESS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WORKER_POOL_ACCESS [DATA]

feature

	submit (pool: separate IMPORTING_WORKER_POOL [DATA, IMPORT_FACTORY [DATA]]; data: separate DATA)
		local
			l_cell: separate DATA_CELL [DATA, IMPORT_FACTORY [DATA]]
		do
			l_cell := pool.get_cell
			put_data (l_cell, data)
			pool.put_cell (l_cell)
		end

feature {NONE}

	put_data (cell: separate DATA_CELL [DATA, IMPORT_FACTORY [DATA]]; data: separate DATA)
		do
			cell.set_item (data)
		end

end
