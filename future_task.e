note
	description: "Summary description for {FUTURE_TASK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	FUTURE_TASK [G -> attached separate ANY]

inherit
	TASK

feature -- Access

	token: separate FUTURE [G]
			-- The result token.
		attribute
			create Result
		end


feature -- Element change

	set_token (a_token: like token)
		do
			token := a_token
		end

feature {NONE} -- Helper function

	set_result (a_token: like token; a_result: G)
			-- Put `a_result' in `a_token'.
		do
			a_token.put (a_result)
		end

end
