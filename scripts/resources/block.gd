class_name Block
extends Resource

@export var name: String
@export var texture: Texture2D
@export var drop: Item
@export var hardness: float= 0.5
@export var has_collision: bool= true
@export var tags: Array[Tag]
@export var particle_color: Color

@export_category("Special")
@export var is_air: bool= false



func has_tag(tag_name: String)-> bool:
	for tag in tags:
		if tag.name == tag_name:
			return true
	return false
