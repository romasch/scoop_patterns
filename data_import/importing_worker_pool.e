note
	description: "Summary description for {IMPORTING_WORKER_POOL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	IMPORTING_WORKER_POOL [DATA, IMPORTER -> IMPORT_FACTORY [DATA] create default_create end]

inherit
	WORKER_POOL [DATA]
		redefine
			make, submit, fetch, is_empty
		end

create
	make

feature

	is_empty: BOOLEAN
			-- Is the work queue of `Current' empty?
		do
			Result := occupied_cells.is_empty
		end

	submit (data: separate DATA)
		local
			importer: IMPORTER
			l_cell: separate DATA_CELL [DATA, IMPORTER]
		do
			if free_cells.is_empty then
				create l_cell.make
			else
				l_cell := free_cells.item
				free_cells.remove
			end

			create importer
			do_import (importer.new_from_separate (data), l_cell)

			occupied_cells.extend (l_cell)
		end


	fetch: separate DATA
		local
			l_cell: separate DATA_CELL [DATA, IMPORTER]
		do
			check from_precondition: not occupied_cells.is_empty end

			l_cell := occupied_cells.item
			occupied_cells.remove
			Result := get_data (l_cell)

			free_cells.put (l_cell)
		end


feature {NONE}

	do_import (data: separate DATA; cell: separate DATA_CELL [DATA, IMPORTER])
		do
			cell.set_item (data)
		end

	get_data (cell: separate DATA_CELL [DATA, IMPORTER]): separate DATA
		local
			l_void: detachable separate DATA
		do
			check attached cell.item as res then
				Result := res
				cell.set_item (l_void)
			end
		end

	occupied_cells: ARRAYED_QUEUE [separate DATA_CELL [DATA, IMPORTER]]

	free_cells: ARRAYED_QUEUE [separate DATA_CELL [DATA, IMPORTER]]


feature {NONE} -- Initialization

	make (a_factory: separate WORKER_FACTORY [separate DATA])
			-- Initialization for `Current'.
		do
			Precursor (a_factory)

			create occupied_cells.make (100)
			create free_cells.make (100)
		end


end
