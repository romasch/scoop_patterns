note
	description: "Summary description for {CANCELABLE_TEST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CANCELABLE_TEST

inherit
	CP_DEFAULT_TASK

create
	default_create, make_from_separate


feature {CP_DYNAMIC_TYPE_IMPORTER}-- Initialization

	make_from_separate (other: separate like Current)
		do
			broker := other.broker
		end

feature

	millisecond: INTEGER_64 = 1_000_000

	run
			-- <Precursor>
		local
			env: EXECUTION_ENVIRONMENT
		do
			from
				create env
			until
				attached broker as l_broker and then is_promise_cancelled (l_broker)
			loop
				env.sleep (200 * millisecond)
			end
		end

end
