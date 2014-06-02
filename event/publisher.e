note
	description: "Summary description for {PUBLISHER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PUBLISHER [EVENT_DATA -> TUPLE]

inherit
	TUPLE_IMPORTER_TESTS [EVENT_DATA]

feature

	event_data: detachable EVENT_DATA

	set_event_data (data: detachable separate EVENT_DATA)
		local
			i: INTEGER
			l_event_data: EVENT_DATA
		do
			if attached data then
				event_data := import (data)
			end
		end

	publish
		do
			across
				subscribers as cursor
			loop
				do_call (cursor.item)
			end
		end


	subscribers: ARRAYED_LIST [separate PROCEDURE [ANY, detachable EVENT_DATA]]
		attribute
			create Result.make (1)
		end

	subscribe (action: separate PROCEDURE [ANY, detachable EVENT_DATA])
		do
			subscribers.extend (action)
		end

	do_call (action: separate PROCEDURE [ANY, detachable EVENT_DATA])
		do
			action.call (event_data)
		end

end
