note
	description : "all_examples application root class"
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
			app: APPLICATION
			buffer: separate CPS_DEFAULT_QUEUE_ACCESS [ANY]
			asdf: separate CPS_IMPORTING_QUEUE_ACCESS [CPS_IMPORTABLE]
		do
			create app.make
		end

end
