extends PlayerState
class_name PlayerBuildingState

signal build_entity(scene, tile_pos)
signal build_block(block, block_state, tile_pos)
signal cancel

enum Type { ENTITY, BLOCK }

var type: Type
var block_entity_definition: BlockEntityDefinition
var ghost: BaseBlockEntity
var ghost_orig_collision_layer: int

var block: Block
var block_pos: Vector2i: set= set_block_pos
var block_state: Block.State
var block_sprite: Sprite2D

var empty_tile: Vector2i



func init(buildable: Buildable):
	match buildable.type:
		Buildable.Type.BLOCK:
			init_block(buildable.ptr)
		Buildable.Type.ENTITY:
			init_block_entity(buildable.ptr)


func on_exit():
	if ghost:
		ghost.queue_free()
	if block_sprite:
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
	block_sprite.show()


func handle_block_entity_input():
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		build_entity.emit(block_entity_definition, empty_tile)


func handle_block_entity_pos_update():
	var valid_pos= null
	
	var size: Vector2i= block_entity_definition.size
	# TODO remove duplicate positions ( if size.x/y == 1 )
	var test_positions= [ empty_tile, empty_tile - Vector2i(size.x - 1, 0),\
			empty_tile - Vector2i(0, size.y - 1), empty_tile - size - Vector2i.ONE]

	for pos in test_positions:
		if player.get_world().can_spawn_block_entity_at(ghost, pos):
			valid_pos= pos
			break
	
	if valid_pos == null: return
	
	ghost.position= get_world().map_to_local(valid_pos) - Vector2.ONE * World.TILE_SIZE / 2
	ghost.show()
	
	DebugHud.send("Ghost Pos", str(ghost.position))


func init_block_entity(be_definition: BlockEntityDefinition):
	type= Type.ENTITY
	block_entity_definition= be_definition
	ghost= be_definition.scene.instantiate()
	ghost.type= be_definition
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
	block_sprite.modulate= get_ghost_modulate_color(true)
	add_child(block_sprite)
	
	block_sprite.top_level= true
	block_sprite.hide()


func set_block_pos(tile_pos: Vector2i):
	if block_pos == tile_pos: return
	block_pos= tile_pos


func get_ghost_modulate_color(valid: bool)-> Color:
	var color= Color.WHITE.lerp(Color.TRANSPARENT, 0.5)
	if not valid:
		color= color.lerp(Color.RED, 0.25)
	return color
