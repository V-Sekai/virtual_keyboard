extends EditorPlugin
tool

func get_name(): 
	return "VirtualKeyboard"

func _enter_tree():
	var editor_interface = get_editor_interface()
	
	add_custom_type("VirtualKeyboardLayout", "Resource", preload("virtual_keyboard_layout.gd"), editor_interface.get_base_control().get_icon("Resource", "EditorIcons"))

func _exit_tree():
	remove_custom_type("VirtualKeyboardLayout")