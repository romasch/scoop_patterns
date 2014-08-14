note
	description: "Entry points for performance testing."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PERFORMANCE_TEST

create
	make_scoop_pattern, make_scoop_naive, make_sequential

feature

	Element_count: INTEGER = 200

	emitter: EMITTER

	make_scoop_pattern
		local
			test: LES_FUTURE_SOLVER
		do
			create emitter.make ("pattern.csv")

			emitter.start ("pattern_init")
			create test.make_random (Element_count)
			emitter.stop

			emitter.start ("pattern_solve")
			test.solve
			emitter.stop

			if not test.is_singular then
				emitter.write_results
			else
				print ("Error: singular matrix.%N")
			end

			make_scoop_naive


		end

	make_scoop_naive
		local
			test: LES_RAW_SCOOP_SOLVER
		do
			create emitter.make ("naive.csv")
			emitter.start ("naive_init")
			create test.make_random (Element_count)
			emitter.stop

			emitter.start ("naive_solve")
			test.solve
			emitter.stop

			if not test.is_singular then
				emitter.write_results
			else
				print ("Error: singular matrix.%N")
			end
		end

	make_sequential
		do
			create emitter.make ("sequential.csv")
			make_scoop_pattern
		end

end
