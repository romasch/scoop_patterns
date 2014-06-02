note
	description: "Summary description for {RECEIVER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RECEIVER [DATA, IMPORTER -> IMPORT_FACTORY [DATA] create default_create end]

create
	make

feature

	receive: DATA
		do
			Result := do_receive (channel)
		end

feature {NONE} -- Implementation

	do_receive (a_channel: like channel): DATA
		require
				-- wait for data to be available
			a_channel.data_available
		do
			check from_precondition: attached a_channel.data as s_data then

					-- receive data (optional: use channel -> single copy)
					-- release channel
				Result := imp.new_from_separate (s_data)
				a_channel.erase_data
			end
		end

feature {NONE} -- Initialization

	make (a_channel: like channel)
		do
			channel := a_channel
			create imp
		end

	imp: IMPORTER

	channel: separate CHANNEL [DATA, IMPORTER]

end
