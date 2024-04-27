class_name Item
extends MyNamedResource

@export var texture: Texture2D
@export var can_stack: bool= true
@export var tags: Array[Tag]


@export_category("Misc")
@export var fuel_value: float= 0
