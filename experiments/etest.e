note
	description: "Summary description for {ETEST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

expanded class
	ETEST

inherit ANY redefine default_create end

create default_create

feature

	item: ANY

	default_create do create item end

end
