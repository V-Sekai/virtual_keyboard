@tool
extends Resource

class VKButton extends RefCounted:
	class  VKButtonType :
		const VK_BUTTON_UNICODE=0
		const VK_BUTTON_SHIFT=1
		const VK_BUTTON_BACKSPACE=2
		const VK_BUTTON_RETURN=3
		const VK_BUTTON_SYMBOLS=4

	
	var vk_button_type : int = VKButtonType.VK_BUTTON_UNICODE:
		set = set_button_type,
		get =get_button_type
	var vk_expand : bool = false:
		set = set_expand,
		get = get_expand
	var vk_input_string : String = "":
		set = set_input_string,
		get =get_input_string
	var vk_shift_input_string : String = "":
		set = set_shift_input_string,
		get = get_shift_input_string
	var vk_symbol_input_string : String = "":
		set = set_symbol_input_string,
		get = get_symbol_input_string
	
	func set_button_type(p_type):
		vk_button_type = p_type
		
	func get_button_type():
		return vk_button_type
		
	func set_expand(p_expand):
		vk_expand = p_expand
		
	func get_expand():
		return vk_expand
		
	# Input String
	func set_input_string(p_string):
		vk_input_string = p_string
		
	func get_input_string():
		return vk_input_string
		
	# Shift Input String
	func set_shift_input_string(p_string):
		vk_shift_input_string = p_string
		
	func get_shift_input_string():
		return vk_shift_input_string
		
		
	# Symbol Input String
	func set_symbol_input_string(p_string):
		vk_symbol_input_string = p_string
		
	func get_symbol_input_string():
		return vk_symbol_input_string
	
	static func get_button_type_enum_string():
		return "Unicode,Shift,Backspace,Return,Symbols"

class VKRow extends RefCounted:
	var button_count : int = 0
	var buttons : Array = []
	
	func get_button_count():
		return button_count

# FIXME: GDScript workaround: This was meant to be a member function but cannot access VKButton.
func set_row_button_count(p_row, p_count):
	p_row.button_count = p_count
	if p_row.button_count < 0:
		p_row.button_count = 0
	p_row.buttons.resize(p_row.button_count)

	for i in range(0, p_row.buttons.size()):
		if p_row.buttons[i] == null:
			p_row.buttons[i] = VKButton.new()

var row_count : int = 0 :
	set = set_row_count,
	get = get_row_count

var rows : Array = []

func set_row_count(p_row_count):
	row_count = p_row_count
	if row_count < 0:
		row_count = 0
	rows.resize(row_count)
	
	for i in range(0, rows.size()):
		if rows[i] == null:
			rows[i] = VKRow.new()
			
	notify_property_list_changed()
	
func get_row_count():
	return row_count

func _set(p_property, p_value):
	var split_property = p_property.split("/", -1)
	if split_property.size() > 0:
		if (split_property[0] == "row_count"):
			if split_property.size() == 1:
				if split_property[0] == "row_count":
					set_row_count(p_value)
		elif (split_property[0] == "rows"):
			if split_property.size() >= 2:
				var row_idx = split_property[1].to_int()
				if rows.size() >= row_idx and rows[row_idx] is VKRow:
					if split_property.size() >= 3:
						if split_property[2] == "button_count":
								set_row_button_count(rows[row_idx], p_value)
								notify_property_list_changed()
						elif split_property[2] == "buttons":
							if split_property.size() >= 3:
								var button_idx = split_property[3].to_int()
								if rows[row_idx].buttons.size() >= button_idx and rows[row_idx].buttons[button_idx] is VKButton:
									if split_property.size() >= 4:
										if split_property[4] == "button_type":
											rows[row_idx].buttons[button_idx].set_button_type(p_value)
										if split_property[4] == "expand":
											rows[row_idx].buttons[button_idx].set_expand(p_value)
										if split_property[4] == "input_string":
											rows[row_idx].buttons[button_idx].set_input_string(p_value)
										if split_property[4] == "shift_input_string":
											rows[row_idx].buttons[button_idx].set_shift_input_string(p_value)
										if split_property[4] == "symbol_input_string":
											rows[row_idx].buttons[button_idx].set_symbol_input_string(p_value)
											
func _get(p_property):
	var split_property = p_property.split("/", -1)
	if split_property.size() > 0:
		if (split_property[0] == "row_count"):
			if split_property.size() == 1:
				if split_property[0] == "row_count":
					return get_row_count()
		elif (split_property[0] == "rows"):
			if split_property.size() >= 2:
				var row_idx = split_property[1].to_int()
				if rows.size() >= row_idx and rows[row_idx] is VKRow:
					if split_property.size() >= 3:
						if split_property[2] == "button_count":
							return rows[row_idx].get_button_count()
						elif split_property[2] == "buttons":
							if split_property.size() >= 3:
								var button_idx = split_property[3].to_int()
								if rows[row_idx].buttons.size() >= button_idx and rows[row_idx].buttons[button_idx] is VKButton:
									if split_property.size() >= 4:
										if split_property[4] == "button_type":
											return rows[row_idx].buttons[button_idx].get_button_type()
										if split_property[4] == "expand":
											return rows[row_idx].buttons[button_idx].get_expand()
										if split_property[4] == "input_string":
											return rows[row_idx].buttons[button_idx].get_input_string()
										if split_property[4] == "shift_input_string":
											return rows[row_idx].buttons[button_idx].get_shift_input_string()
										if split_property[4] == "symbol_input_string":
											return rows[row_idx].buttons[button_idx].get_symbol_input_string()
											
func _get_property_list():
	var property_list = []
	
	property_list.push_back({"name":"row_count", "type": TYPE_INT, "hint":PROPERTY_HINT_NONE})
	for i in range(0, row_count):
		var row_path = "rows/" + str(i) + "/"
		property_list.push_back({"name":row_path + "button_count", "type": TYPE_INT, "hint":PROPERTY_HINT_NONE})
		for j in range(0, rows[i].button_count):
			var button_path = row_path + "buttons/" + str(j) + "/"
			property_list.push_back({"name":button_path + "button_type", "type": TYPE_INT, "hint":PROPERTY_HINT_ENUM, "hint_string":VKButton.get_button_type_enum_string()})
			property_list.push_back({"name":button_path + "expand", "type": TYPE_BOOL, "hint":PROPERTY_HINT_NONE})
			property_list.push_back({"name":button_path + "input_string", "type": TYPE_STRING, "hint":PROPERTY_HINT_NONE})
			property_list.push_back({"name":button_path + "shift_input_string", "type": TYPE_STRING, "hint":PROPERTY_HINT_NONE})
			property_list.push_back({"name":button_path + "symbol_input_string", "type": TYPE_STRING, "hint":PROPERTY_HINT_NONE})
		
	return property_list
