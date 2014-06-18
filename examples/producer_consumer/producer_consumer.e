note
	description: "Root class for the producer/consumer example."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PRODUCER_CONSUMER

create
	make

feature {NONE} -- Initialization

	make
			-- Launch the producer and consumers.
		local
				-- Note the choice of types: We want to copy strings across processor boundaries,
				-- therefore we use a CPS_STRING_IMPORTER.
				-- An alternative would be to avoid copies with CPS_NO_IMPORT, but then a new
				-- processor has to be created for every string object.
			l_queue: separate CP_QUEUE [STRING, CPS_STRING_IMPORTER]
			l_producer: separate PRODUCER
			l_consumer: separate CONSUMER
		do
			print ("%NStarting producer/consumer example. %N%N")

				-- Create a shared bounded queue for data exchange.
			create l_queue.make_bounded (queue_size)

				-- Create and launch the consumers.
			across 1 |..| consumer_count as i loop
				create l_consumer.make (l_queue, i.item)
				launch_consumer (l_consumer, items_per_consumer)

					-- Note: It may be tempting to merge `{CONSUMER}.consume' with the creation
					-- procedure to avoid writing the `lanuch_consumer' feature in this class.
					-- This doesn't work however, because in that case the consumer will hold
					-- a lock on the shared buffer throughout its whole life.
			end

				-- Create and launch the producers.
			across 1 |..| producer_count as i loop
				create l_producer.make (l_queue, i.item)
				launch_producer (l_producer, items_per_producer)
			end

		end


feature -- Constants

	queue_size: INTEGER = 5

	producer_count: INTEGER = 10

	consumer_count: INTEGER = 10

	items_per_producer: INTEGER = 20

	items_per_consumer: INTEGER = 20

feature {NONE} -- Implementation

	launch_consumer (a_consumer: separate CONSUMER; count: INTEGER)
			-- Instruct `a_consumer' to consume `count' items.
		do
			a_consumer.consume (count)
		end

	launch_producer (a_producer: separate PRODUCER; count: INTEGER)
			-- Instruct `a_producer' to produce `count' items.
		do
			a_producer.produce (count)
		end

invariant
	equal_values: producer_count * items_per_producer = consumer_count * items_per_consumer
end
