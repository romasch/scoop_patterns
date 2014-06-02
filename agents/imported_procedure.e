note
	description: "Summary description for {IMPORTED_PROCEDURE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	IMPORTED_PROCEDURE [TARGET -> detachable ANY]

inherit
	PROCEDURE [TARGET, TUPLE [TARGET]]

create
	make_from_separate

feature

	make_from_separate (other: attached separate PROCEDURE [TARGET, TUPLE [TARGET]] )
			-- Initialize from `other'.
		do
			check other.open_count = 1 and not other.is_target_closed end

			rout_disp := other.rout_disp
			encaps_rout_disp := other.encaps_rout_disp
			calc_rout_addr := other.calc_rout_addr

--			closed_operands := other.closed_operands
--			operands := other.operands
			closed_operands := []
			operands := Void

			class_id := other.class_id
			feature_id := other.feature_id
			is_precompiled := other.is_precompiled
			is_basic := other.is_basic
			is_target_closed := other.is_target_closed
			is_inline_agent := other.is_inline_agent
			open_count := other.open_count

				-- new
			create open_map.make_filled (1, 1, 1)
			open_types := Void
		end

end
