extends PlayerState

signal build_entity(scene, tile_pos)
signal build_block(block, block_state, tile_pos)
signal cancel

enum Type { ENTITY, BLOCK }

var type: Type
var entity_scene: PackedScene
var ghost: BaseBlockEntity
var ghost_orig_collision_layer: int

var block: Block
var block_pos: Vector2i: set= set_block_pos
var block_state: Block.State
var block_sprite: Sprite2D

var empty_tile: Vector2i



func on_enter():
	init_block(DataManager.get_block_from_name("stone_ramp"))


func on_exit():
	block_sprite.queue_free()


func on_physics_process(delta: float):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		cancel.emit()
	
	match type:
		Type.BLOCK:
			handle_block_input()
		Type.ENTITY:
			handle_block_entity_input()

	if player.ray_cast.is_colliding():
		var new_empty_tile= get_empty_tile()
		if empty_tile == new_empty_tile: return
		
		empty_tile= new_empty_tile

		if player.is_in_tile(empty_tile): return
		
		DebugHud.send("Empty Tile", str(empty_tile))
		
		match type:
			Type.BLOCK:
				handle_block_pos_update()
			Type.ENTITY:
				handle_block_entity_pos_update()


func handle_block_input(): 
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		build_block.emit(block, block_state, block_pos)
		return

	if Input.is_action_just_pressed("change_block_state"):
		if block.can_flip_horizontal:
			block_state= Block.State.FLIP_HORIZONTAL if block_state == Block.State.NONE else Block.State.NONE
		elif block.can_flip_vertical:
			block_state= Block.State.FLIP_VERTICAL if block_state == Block.State.NONE else Block.State.NONE
	
		block_sprite.flip_h= block_state == Block.State.FLIP_HORIZONTAL
		block_sprite.flip_v= block_state == Block.State.FLIP_VERTICAL


func handle_block_pos_update():
	block_pos= empty_tile
	block_sprite.position= player.get_world().map_to_local(block_pos)


func handle_block_entity_input():
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		build_entity.emit(entity_scene, empty_tile)


func handle_block_entity_pos_update():
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


func init_block_entity(scene: PackedScene):
	type= Type.ENTITY
	ghost= scene.instantiate()
	
	ghost_orig_collision_layer= ghost.collision_layer
	ghost.collision_layer= 0
	add_child(ghost)
	
	ghost.modulate= get_ghost_modulate_color(false)
	ghost.top_level= true
	ghost.hide()


func init_block(_block: Block):
	type= Type.BLOCK
	block= _block
	block_sprite= Sprite2D.new()
	block_sprite.texture= block.texture
	block_sprite.modulate= get_ghost_modulate_color(false)
	add_child(block_sprite)
	
	block_sprite.top_level= true
 

func set_block_pos(tile_pos: Vector2i):
	if block_pos == tile_pos: return
	block_pos= tile_pos


func get_ghost_modulate_color(valid: bool)-> Color:
	var color= Color.WHITE.lerp(Color.TRANSPARENT, 0.5)
	if not valid:
		color= color.lerp(Color.RED, 0.25)
	return color
