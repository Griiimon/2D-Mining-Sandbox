class_name Block
extends MyNamedResource

enum State { NONE, FLIP_HORIZONTAL, FLIP_VERTICAL, ROTATE_90_DEG, ROTATE_180_DEG, ROTATE_270_DEG }


@export var texture: Texture2D
@export var drop: Item
@export var hardness: float= 0.5
@export var has_collision: bool= true
@export var tags: Array[Tag]
@export var particle_color: Color
@export var material: MaterialSoundLibrary.Type= MaterialSoundLibrary.Type.ROCK


@export_category("Tools")
@export var mining_tool: HandItem.Type= HandItem.Type.PICK_AXE
@export var other_tool_penalty: float= 4.0
@export var other_tool_produces_drops: bool= false

@export_category("Special")
@export var schedule_tick: bool= false
@export var is_air: bool= false
@export var is_fluid: bool= false


@export var custom_collision_polygon: PackedVector2Array



func has_tag(tag_name: String)-> bool:
	for tag in tags:
		if tag.name == tag_name:
			return true
	return false


func can_be_mined()-> bool:
	return not is_fluid and not is_air


func on_spawn(_world: World, _block_pos: Vector2i):
	pass


func on_break(_world: World, _block_pos: Vector2i):
	pass


func on_tick(_world: World, _block_pos: Vector2i):
	pass


func on_neighbor_update(_world: World, _block_pos: Vector2i, _neighbor_pos: Vector2i):
	pass


func move(world: World, block_pos: Vector2i, direction: Vector2i):
	world.delete_block(block_pos)
	world.set_block(self, block_pos + direction)


func replace(world: World, block_pos: Vector2i, new_block: Block):
	world.delete_block(block_pos)
	world.set_block(new_block, block_pos)


func on_chunk_generated(_world: World, _block_pos: Vector2i):
	pass


func on_random_update(_world: World, _block_pos: Vector2i):
	pass


static func get_state_from_alt(alt_tile: int)-> State:
	if alt_tile & TileSetAtlasSource.TRANSFORM_FLIP_H:
		return Block.State.FLIP_HORIZONTAL
	elif alt_tile & TileSetAtlasSource.TRANSFORM_FLIP_V:
		return Block.State.FLIP_VERTICAL
	return Block.State.NONE


static func get_alt_from_state(state: State)-> int:
	var alt:= 0
	match state:
		Block.State.FLIP_HORIZONTAL:
			alt+= TileSetAtlasSource.TRANSFORM_FLIP_H
		Block.State.FLIP_VERTICAL:
			alt+= TileSetAtlasSource.TRANSFORM_FLIP_V
	return alt


func is_solid()-> bool:
	return not is_fluid and not is_air


func get_atlas_texture()-> Texture2D:
	return texture


func get_display_name()-> String:
	return name.capitalize() + " Block"
