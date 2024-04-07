class_name HandItem
extends Item

enum Type { PICK_AXE, SHOVEL, MELEE_WEAPON, THROWABLE, CUSTOM }

@export var type: Type

@export var tier: int
