extends PlayerState

signal build_entity(scene, tile_pos)
signal build_block(block, alternate_id, tile_pos)
signal cancel

enum Type { Entity, Block }

var type: Type
var entity_scene: PackedScene
var ghost: BaseBlockEntity
var ghost_orig_collision_layer: int

var block: Block
var block_alternate_id: int

var empty_tile: Vector2i



func on_enter():
	
	init_block_entity(scene)
	type= Type.Entity
	entity_scene= load("res://game/block entities/furnace/furnace.tscn")
	ghost= entity_scene.instantiate()
	ghost_orig_collision_layer= ghost.collision_layer
	ghost.collision_layer= 0
	add_child(ghost)
	ghost.modulate= get_ghost_modulate_color(true)
	ghost.top_level= true
	ghost.hide()


func on_physics_process(delta: float):
	if player.ray_cast.is_colliding():
		var new_empty_tile= get_empty_tile()
		if empty_tile == new_empty_tile: return
		
		empty_tile= new_empty_tile

		if player.is_in_tile(empty_tile): return
		
		DebugHud.send("Empty Tile", str(empty_tile))
		
		var valid_pos= null
		
		# TODO remove duplicate positions ( if size.x/y == 1 )
		var test_positions= [ empty_tile, empty_tile - Vector2i(ghost.size.x - 1, 0),\
				empty_tile - Vector2i(0, ghost.size.y - 1), empty_tile - ghost.size - Vector2i.ONE]

		for pos in test_positions:
			if player.get_world().can_spawn_block_entity_at(ghost, pos):
				valid_pos= pos
				break
		
		if valid_pos == null: return
		
		ghost.show()
		ghost.position= get_world().map_to_local(valid_pos) - Vector2.ONE * World.TILE_SIZE / 2
		
		DebugHud.send("Ghost Pos", str(ghost.position))
		
		
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			build_entity.emit(entity_scene, empty_tile)


func init_block_entity(scene: PackedScene):
	type= Type.Entity
	ghost= scene.instantiate()
	
	ghost_orig_collision_layer= ghost.collision_layer
	ghost.collision_layer= 0
	add_child(ghost)
	
	ghost.modulate= get_ghost_modulate_color(true)
	ghost.top_level= true
	ghost.hide()


func get_ghost_modulate_color(valid: bool)-> Color:
	var color= Color.WHITE.lerp(Color.TRANSPARENT, 0.5)
	if not valid:
		color= color.lerp(Color.RED, 0.25)
	return color
