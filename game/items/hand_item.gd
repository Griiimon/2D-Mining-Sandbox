class_name HandItem
extends Item

enum Type { NONE, PICK_AXE, SHOVEL, MELEE_WEAPON, THROWABLE, CUSTOM }

@export var type: Type
@export var tier: int
@export var scene: PackedScene

@export var material: MaterialSoundLibrary.Type
@export var mining_animation: String
@export var primary_action_animation: String
@export var secondary_action_animation: String

@export var charge_primary_action: bool= false
@export var charge_secondary_action: bool= false



func can_mine()-> bool:
	match type:
		Type.PICK_AXE, Type.SHOVEL, Type.MELEE_WEAPON:
			return true
	return false
