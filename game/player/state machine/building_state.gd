extends PlayerState

signal build(scene, tile_pos)
signal cancel

enum Type { Entity, Block }

var type: Type
var entity_scene: PackedScene
var ghost: BaseBlockEntity
var ghost_orig_collision_layer: int
var block: Block

var empty_tile: Vector2i: set= set_empty_tile



func on_enter():
	
	type= Type.Entity
	entity_scene= load("res://game/block entities/furnace/furnace.tscn")
	ghost= entity_scene.instantiate()
	ghost_orig_collision_layer= ghost.collision_layer
	ghost.collision_layer= 0
	add_child(ghost)
	ghost.modulate= Color.WHITE.lerp(Color.TRANSPARENT, 0.5).lerp(Color.RED, 0.25)
	ghost.top_level= true
	ghost.hide()


func on_physics_process(delta: float):
	if player.ray_cast.is_colliding():
		empty_tile= get_empty_tile()

		if player.is_in_tile(empty_tile): return
		
		DebugHud.send("Empty Tile", str(empty_tile))
		
		if not player.get_world().can_spawn_block_entity_at(ghost, empty_tile):
			return
		
		ghost.show()
		ghost.position= get_world().map_to_local(empty_tile) - Vector2.ONE * World.TILE_SIZE / 2
		
		DebugHud.send("Ghost Pos", str(ghost.position))
		
		
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			build.emit(entity_scene, empty_tile)


func set_empty_tile(tile_pos: Vector2i):
	if tile_pos == empty_tile: return
	
	empty_tile= tile_pos
