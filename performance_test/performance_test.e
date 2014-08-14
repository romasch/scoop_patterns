note
	description: "Entry points for performance testing."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PERFORMANCE_TEST

create
	make

feature

	element_count: INTEGER

	emitter: EMITTER

	is_singular: BOOLEAN

	make
		do
			create emitter.make ("results.csv")

			io.put_string ("Enter number of elements: ")
			io.read_integer
			element_count := io.last_integer

			emitter.annotate ("count", element_count.out)

			test_partitioned_future
			test_future
			test_scoop_raw
			test_sequential

			emitter.annotate ("is_singular", is_singular.out)

			emitter.write_results
		end

	test_partitioned_future
		local
			test: PARTITIONED_FUTURE_GAUSS_ELIMINATION
		do
			emitter.start ("part_init")
			create test.make_random (Element_count)
			emitter.stop

			emitter.start ("part_solve")
			test.solve
			emitter.stop

			is_singular := is_singular or test.is_singular
		end

	test_future
		local
			test: FUTURE_GAUSS_ELIMINATION
		do
			emitter.start ("future_init")
			create test.make_random (Element_count)
			emitter.stop

			emitter.start ("future_solve")
			test.solve
			emitter.stop

			is_singular := is_singular or test.is_singular
		end

	test_scoop_raw
		local
			test: RAW_SCOOP_GAUSS_ELIMINATION
		do
			emitter.start ("rawscoop_init")
			create test.make_random (Element_count)
			emitter.stop

			emitter.start ("rawscoop_solve")
			test.solve
			emitter.stop

			is_singular := is_singular or test.is_singular
		end

	test_sequential
		local
			test: SEQUENTIAL_GAUSS_ELIMINATION
		do
			emitter.start ("sequential_init")
			create test.make_random (Element_count)
			emitter.stop

			emitter.start ("sequential_solve")
			test.solve
			emitter.stop

			is_singular := is_singular or test.is_singular
		end

end
