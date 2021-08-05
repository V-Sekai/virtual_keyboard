@tool
extends Control

@export var layout : Resource = null

signal key_pressed(p_scancode)

const virtual_keyboard_layout_const = preload("virtual_keyboard_layout.gd")

var button_infos: Dictionary = {}
var shift: bool = false
var symbols: bool = false 
	
func update_buttons() -> void:
	if symbols:
		for button in button_infos.keys():
			button.set_text(button_infos[button].get_symbol_input_string())
	else:
		if shift:
			for button in button_infos.keys():
				button.set_text(button_infos[button].get_shift_input_string())
		else:
			for button in button_infos.keys():
				button.set_text(button_infos[button].get_input_string())

func button_string_callback(p_button_info: RefCounted) -> void:
	match p_button_info.get_button_type():
		virtual_keyboard_layout_const.VKButton.VKButtonType.VK_BUTTON_UNICODE:
			var key_string: String = ""
			if symbols:
				key_string = p_button_info.get_symbol_input_string()
			
			if key_string == "":
				if shift:
					key_string = p_button_info.get_shift_input_string()
				
			if key_string == "":
				key_string = p_button_info.get_input_string()
			
			assert(key_string != "")
			
			emit_signal("key_pressed", key_string[0])
		virtual_keyboard_layout_const.VKButton.VKButtonType.VK_BUTTON_SHIFT:
			shift = !shift
			update_buttons()
		virtual_keyboard_layout_const.VKButton.VKButtonType.VK_BUTTON_SYMBOLS:
			symbols = !symbols
			update_buttons()
		virtual_keyboard_layout_const.VKButton.VKButtonType.VK_BUTTON_BACKSPACE:
			pass
		virtual_keyboard_layout_const.VKButton.VKButtonType.VK_BUTTON_RETURN:
			pass
			
	
static func create_button(p_owner: Node, p_button_info: RefCounted) -> Button:
	var button = Button.new()
	
	if p_button_info.get_expand():
		button.set_h_size_flags(Control.SIZE_EXPAND_FILL)
	else:
		button.set_h_size_flags(Control.SIZE_FILL)
	
	assert(button.connect("pressed", Callable(p_owner, "button_string_callback"), [p_button_info]) == OK)
	
	button.enabled_focus_mode = Control.FOCUS_NONE
		
	return button

func create_from_layout(p_layout):
	if p_layout is virtual_keyboard_layout_const:
		for i in range(0, p_layout.row_count):
			var row = p_layout.rows[i]
			var horizontal_layout = HBoxContainer.new()
			for j in range(0, row.button_count):
				var button_info: RefCounted = row.buttons[j]
				
				var button: Button = create_button(self, button_info)
				button_infos[button] = button_info
				
				horizontal_layout.add_child(button)
				
			update_buttons()
			
			add_child(horizontal_layout)
	else:
		printerr("Invalid layout format!")

func _ready():
	if layout:
		create_from_layout(layout)
