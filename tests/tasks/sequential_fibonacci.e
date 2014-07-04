note
	description: "Summary description for {SEQUENTIAL_FIBONACCI}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEQUENTIAL_FIBONACCI

inherit
	CP_COMPUTATION [INTEGER_64]

create
	make, make_from_separate

feature

	make (i: INTEGER_64)
		require
			i > 0
		do
			input := i
		end

	make_from_separate (other: separate like Current)
		do
			input := other.input
			broker := other.broker
		end


	input: INTEGER_64

	compute: INTEGER_64
			-- <Precursor>
		local
			i, last, tmp: INTEGER_64
		do
			from
				i := 3
				last := 1
				Result := 1
			until
				i > input
			loop
				tmp := Result
				Result := Result + last
				last := tmp
				i := i + 1
			end
		end

end
