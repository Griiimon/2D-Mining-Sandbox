class_name BaseBlockEntity
extends StaticBody2D

# size in tiles
@export var size: Vector2i= Vector2i.ONE
@export var register_tick: bool= false

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var foundation: Array[Vector2i]



func _ready():
	collision_shape.shape.size= size * World.TILE_SIZE
	collision_shape.position= size * World.TILE_SIZE / 2
	

func _exit_tree():
	on_despawn()


func on_despawn():
	if register_tick:
		Global.game.world.unregister_block_entity(self)
		for tile in foundation:
			Global.game.world.unsubscribe_from_block_change(tile, self)


func add_foundation_tile(tile: Vector2i):
	foundation.append(tile)


func finish_foundation(world: World):
	for tile in foundation:
		world.subscribe_to_block_change(tile, check_foundation.bind(world))


func check_foundation(world: World):
	for tile in foundation:
		if world.is_block_solid(tile): return
	
	queue_free()
