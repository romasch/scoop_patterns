note
	description: "Summary description for {SUPPORT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SUPPORT

feature

	new_tuple_with_expanded: TUPLE [ETEST]
		local
			l_exp: ETEST
		do
			create l_exp
			Result := [l_exp]
		end

	wrap (obj: detachable separate ANY): TUPLE [detachable separate ANY]
		do
			Result := [obj]
		end

feature -- Test agents

	failing_agent
		local
			l_exception: DEVELOPER_EXCEPTION
		do
			create l_exception
			l_exception.set_description ("failing_task_test")
			l_exception.raise
		end
end
