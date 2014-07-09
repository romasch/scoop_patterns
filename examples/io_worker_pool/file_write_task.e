note
	description: "A task that can write a string to a file."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	FILE_APPENDER_TASK

inherit

	CP_TASK

create
	make, make_from_separate

feature {NONE} -- Initialization

	make (a_path: STRING; a_content: STRING)
			-- Create a new file writer task.
		do
			path := a_path
			content := a_content
		end

	make_from_separate (other: separate like Current)
			-- <Precursor>
		do
			create path.make_from_separate (other.path)
			create content.make_from_separate (other.content)
			broker := other.broker
		end

feature -- Access

	path: STRING
			-- The path of the file to write to.

	content: STRING
			-- The content to be written.

feature -- Basic operations

	run
			-- <Precursor>
		local
			l_file: PLAIN_TEXT_FILE
		do
			create l_file.make_open_append (path)
			l_file.put_string (content)
			l_file.close
		end

end
