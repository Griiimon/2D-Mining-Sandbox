extends MyNamedResource
class_name BlockEntityDefinition


@export var scene: PackedScene
# size in tiles
@export var size: Vector2i= Vector2i.ONE
@export var register_tick: bool= false

@export var ingredients: Array[InventoryItem]
