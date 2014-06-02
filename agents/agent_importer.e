note
	description: "Summary description for {AGENT_IMPORTER_TESTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AGENT_IMPORTER_TESTS

inherit
	AGENT_IMPORTER

create make, run

feature

	import (ag: separate PROCEDURE [ANY, TUPLE [ANY]]): PROCEDURE [ANY, TUPLE [ANY]]
		do
			Result := import_agent (ag)
		end

	import_failed (ag: separate PROCEDURE [TEST_AGENTS, TUPLE [TEST_AGENTS]]): PROCEDURE [TEST_AGENTS, TUPLE [TEST_AGENTS]]
		require
			not ag.is_target_closed
		local
			res: IMPORTED_PROCEDURE [TEST_AGENTS]
		do
				-- does not work, apparently Eiffel cannot handle descendants of PROCEDURE
			create res.make_from_separate (ag)
			Result := res
		end

	make
		local
			ag: PROCEDURE [TEST_AGENTS, TUPLE [TEST_AGENTS]]
			sep: separate AGENT_IMPORTER_TESTS
		do
			ag := agent {TEST_AGENTS}.print_numbers (42, 21)
			create sep.run (ag)

		end

	run (ag: separate PROCEDURE [TEST_AGENTS, TUPLE [TEST_AGENTS]])
		local
			my_ag: PROCEDURE [ANY, TUPLE [ANY]]
		do
			my_ag := import (ag)
			my_ag.call (create {TEST_AGENTS})
		end

end
