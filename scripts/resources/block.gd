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
@export var is_air: bool= false



func has_tag(tag_name: String)-> bool:
	for tag in tags:
		if tag.name == tag_name:
			return true
	return false


func on_spawn(_world: World, _block_pos: Vector2i):
	pass


func on_break(_world: World, _block_pos: Vector2i):
	pass


func on_tick(_world: World, _block_pos: Vector2i):
	pass
