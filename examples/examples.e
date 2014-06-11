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
		do
			--| Add your code here
			print ("Hello Eiffel World!%N")
		end

end
