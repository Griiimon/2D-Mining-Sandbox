class_name HandItem
extends Item

enum Type { PICK_AXE, SHOVEL, MELEE_WEAPON, THROWABLE, CUSTOM }

@export var type: Type
@export var tier: int
@export var scene: PackedScene

@export var mining_animation: String


func can_mine()-> bool:
	match type:
		Type.PICK_AXE, Type.SHOVEL, Type.MELEE_WEAPON:
			return true
	return false
