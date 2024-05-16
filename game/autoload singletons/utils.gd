class_name Utils



static func chancef(chance: float)-> bool:
	return randf() < chance


static func chance100(chance: float)-> bool:
	return chancef(chance / 100.0)


static func chance50()-> bool:
	return chance100(50)


static func load_directory_recursively(path: String)-> Array[String]:
	var result: Array[String]= []
	path+= "/"
	var dir:= DirAccess.open(path)
	
	for sub_dir in dir.get_directories():
		result.append_array(load_directory_recursively(path + sub_dir))
	
	for file in dir.get_files():
		result.append(path + file)
	
	return result


static func get_health(node: Node)-> HealthComponent:
	if node is HurtBox:
		return (node as HurtBox).health_component
	if node is BaseBlockEntity:
		return node.get_node_or_null(Global.HEALT_COMPONENT_NODE)
	return null


static func build_mask(bits: Array[int])-> int:
	var result:= 0
	for bit in bits:
		result+= int(pow(2, bit - 1))
	return result


static func free_children(node: Node):
	for child in node.get_children():
		child.free()


static func find_custom_children(parent: Node, type)-> Array[Node]:
	var result: Array[Node]= []
	
	for child in parent.get_children():
		if is_instance_of(child, type):
			result.append(child)
		result.append_array(find_custom_children(child, type))
	
	return result


static func find_custom_parent(child: Node, type)-> Node:
	if not child.get_parent(): return null
	if is_instance_of(child.get_parent(), type):
		return child.get_parent()
	return find_custom_parent(child.get_parent(), type)


static func make_ingredient_list(control: Control, ingredients: Array[InventoryItem]):
	for ingredient in ingredients:
		var label:= Label.new()
		label.text= "%dx %s" % [ingredient.count, ingredient.item.get_display_name()]
		control.add_child(label)


static func get_time_string(time: float)-> String:
	var time_int: int= int(time)
	var seconds = time_int % 60
	@warning_ignore("integer_division")
	var minutes = (time_int / 60) % 60
	@warning_ignore("integer_division")
	var hours = (time_int / 60) / 60

	return "%02d:%02d:%02d" % [hours, minutes, seconds]	


static func is_starting()-> bool:
	return Engine.get_process_frames() == 0
