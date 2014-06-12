note
	description:
	"[
		Queue that imports objects.
		This queue is suitable for small reference objects
		that inherit from IMPORTABLE.
		
		Note:
		Objects inserted into this queue can (and should) be
		created on the producer's processor, as they get
		copied anyway.
		
		Note: The type of the copied objects will be G, even
		if the inserted object is of a subtype of G.
	]"
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	CPS_IMPORTING_QUEUE [G -> CPS_IMPORTABLE create make_from_separate end]

--inherit
--	CPS_QUEUE [G, CPS_DEFAULT_IMPORTER [G]]

--create
--	make_bounded, make_unbounded

--feature

--	count: INTEGER = 0

--	make_bounded (a_capacity: INTEGER)
--			do

--			end

--	make_unbounded
--			do

--			end
end
