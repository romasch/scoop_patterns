note
	description: "Summary description for {ECHO_SERVER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ECHO_SERVER

inherit
	CP_CONTINUOUS_PROCESS
		redefine
			finish
		end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			create socket.make_server_by_port (port_number)
			check socket.is_bound end
			socket.set_linger_off
			socket.listen (1)
		end

feature -- Basic operations

	step
			-- <Precursor>
		local
			l_received: STRING
		do
			socket.accept
			if attached socket.accepted as l_answer_socket then
				l_answer_socket.read_line
				l_received := l_answer_socket.last_string
				if l_received.starts_with ("stop") then
					is_stopped := True
				else
					l_answer_socket.put_string (l_received)
					l_answer_socket.put_new_line
					l_answer_socket.close
				end
			end
		end

	finish
			-- <Precursor>
		do
			socket.cleanup
		end

feature -- Constants

	port_number: INTEGER = 2002

feature {NONE} -- Implementation

	socket: NETWORK_STREAM_SOCKET
			-- The network socket to send and receive STRING objects.

end
