class_name Block
extends Resource

@export var name: String
@export var texture: Texture2D
@export var drop: Item
@export var hardness: float= 0.5
@export var has_collision: bool= true
@export var tags: Array[Tag]
@export var particle_color: Color

@export_category("Tools")
@export var mining_tool: HandItem.Type= HandItem.Type.PICK_AXE
@export var other_tool_penalty: float= 4.0
@export var other_tool_produces_drops: bool= false

@export_category("Special")
@export var schedule_tick: bool= false
@export var is_air: bool= false
@export var is_fluid: bool= false



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
	world.set_block(block_pos + direction, self)


func replace(world: World, block_pos: Vector2i, new_block: Block):
	world.delete_block(block_pos)
	world.set_block(block_pos, new_block)


func is_solid()-> bool:
	return not is_fluid and not is_air
