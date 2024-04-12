extends Node2D
class_name Hand


func set_attack_state(b: bool):
	assert(get_child_count() == 1)
	(get_child(0) as HandItemObject).set_attack_state(b)
