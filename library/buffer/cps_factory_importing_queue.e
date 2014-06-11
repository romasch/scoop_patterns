note
	description:
	"[
		Queue that imports objects.
		This queue is suitable for small reference objects
		that can be imported with the help of a factory object.

		Note:
		Objects inserted into this queue can (and should) be
		created on the producer's processor, as they get
		copied anyway.
	]"
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	CPS_FACTORY_IMPORTING_QUEUE [G]

inherit
	CPS_QUEUE [G]

create
	make_bounded, make_unbounded

feature

	count: INTEGER = 0

	make_bounded (a_capacity: INTEGER)
			do

			end

	make_unbounded
			do

			end

end
