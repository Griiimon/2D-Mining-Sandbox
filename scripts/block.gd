class_name Block
extends Resource

@export var name: String
@export var texture: Texture2D
@export var drop: Item
@export var hardness: float= 0.5
@export var has_collision: bool= true
@export var tags: Array[Tag]


func has_tag(tag_name: String)-> bool:
	for tag in tags:
		if tag.name == tag_name:
			return true
	return false
