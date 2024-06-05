class_name BaseBlockEntity
extends StaticBody2D



@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var type: BlockEntityDefinition
var foundation: Array[Vector2i]



func _ready():
	assert(type)
	collision_shape.shape.size= type.size * World.TILE_SIZE
	collision_shape.position= type.size * World.TILE_SIZE / 2
	

func _exit_tree():
	on_despawn()


func tick(_world: World):
	pass


func on_despawn():
	if type.register_tick:
		Global.game.world.unregister_block_entity(self)
		for tile in foundation:
			Global.game.world.unsubscribe_from_block_change(tile, self)


func add_foundation_tile(tile: Vector2i):
	foundation.append(tile)


func finish_foundation(world: World):
	for tile in foundation:
		world.subscribe_to_block_change(tile, check_foundation)


func check_foundation(world: World, auto_delete: bool= true):
	for tile in foundation:
		if world.is_block_solid_at(tile): return
	
	if auto_delete:
		queue_free()


func get_display_name()-> String:
	return type.get_display_name()
