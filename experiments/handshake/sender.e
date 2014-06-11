note
	description: "Summary description for {SENDER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SENDER [DATA]

create
	make

feature

	send (data: detachable separate DATA)
		do
			if attached data then
					-- place data
					-- release channel
				place_data (data, channel)
					-- (optional) wait for data to be retrieved
				block (channel)
			end
		end

feature {NONE} -- Implementation

	place_data (a_data: attached separate DATA; a_channel: like channel)
		require
				-- don't overwrite someone else's data.
			not a_channel.data_available
		do
			a_channel.put_data (a_data)
		ensure
			a_channel.data_available
		end

	block (a_channel: like channel)
		require
			not a_channel.data_available
		do
		end

feature {NONE} -- Initialization

	channel: separate CHANNEL [DATA, IMPORT_FACTORY [DATA]]

	make (a_channel: like channel)
		do
			channel := a_channel
		end

end
