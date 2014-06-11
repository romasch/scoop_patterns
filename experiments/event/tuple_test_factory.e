note
	description: "Summary description for {TUPLE_TEST_FACTORY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TUPLE_TEST_FACTORY

feature

	test_integer: TUPLE [INTEGER, INTEGER]
		do
			Result := [4,2]
		end


	test_ref: TUPLE [CELL[INTEGER]]
		do
			Result := [create {CELL[INTEGER]}.put (42)]
		end

end
