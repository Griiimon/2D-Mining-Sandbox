class_name MyNamedResource
extends Resource


@export var name: String


func get_display_name()-> String:
	return name.capitalize()
