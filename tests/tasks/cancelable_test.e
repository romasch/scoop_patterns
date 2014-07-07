note
	description: "Summary description for {CANCELABLE_TEST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CANCELABLE_TEST

inherit
	CP_TASK

create
	default_create, make_from_separate

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
				attached broker as l_broker and then is_broker_cancelled (l_broker)
			loop
				env.sleep (200 * millisecond)
			end
		end

	make_from_separate (other: separate like Current)
		do
			broker := other.broker
		end

end
