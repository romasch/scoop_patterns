note
	description: "Internal class to create a separate processor holding all broker objects."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	CP_BROKER_PROCESSOR

inherit
	CP_DYNAMIC_TYPE_IMPORTER [CP_IMPORTABLE]
		export {CP_BROKER_UTILS}
			import
		end


feature {CP_BROKER_UTILS}

	new_broker: CP_SHARED_BROKER
			-- Create a new broker on the global pool.
		do
			create Result.make
		end

end
