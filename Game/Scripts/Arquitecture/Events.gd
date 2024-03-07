extends Node

#Data: max global point
signal on_grow(tree_type, focus_point)

#Data: 
signal open_popup(data)
signal close_popup(data)

signal open_screen(data)
signal close_screen(data)

signal on_groundwater_fineshed(data)

#For visual effects
signal on_SC_changed(data)
signal on_HC_changed(data)

signal disable_scroll()
signal enable_scroll()

signal enable_follow_mode()
signal disable_follow_mode()

signal on_ground_element_reveal(to)
signal on_start_pump(data)

signal root_full_grown()
signal on_emptied_groundwater(groundwater)

