note
	description:
	"[
		Import strategy: Copy objects to the local processor.
		
		Note: The type of the imported object will be the static type G,
		not the dynamic type of the original object.
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CPS_STATIC_TYPE_IMPORTER [G -> CPS_IMPORTABLE create make_from_separate end]

inherit
	CPS_IMPORTER [G]

feature

	import (obj: separate G): G
			-- <Precursor>
		do
			create Result.make_from_separate (obj)
		end

end
