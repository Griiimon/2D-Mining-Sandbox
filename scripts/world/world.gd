#@tool
class_name World
extends Node2D

const ENTITY_TICKS= 60

const TILE_SIZE= 32

@export var world_item_scene: PackedScene

@export var chunks: Node2D

var tick_entities: Array[BaseBlockEntity]



func _physics_process(delta):
	if Engine.is_editor_hint(): return
	
	for entity in tick_entities:
		entity.tick(self)


func get_block(tile_pos: Vector2i)-> Block:
	var block_id: int= get_block_id(tile_pos)
	if block_id == -1:
		return null
	return DataManager.blocks[block_id]


func get_block_id(tile_pos: Vector2i):
	var chunk: WorldChunk= get_chunk_at(tile_pos)
	if not chunk: 
		assert(false)
		return null
	return chunk.get_block_id(tile_pos)


func get_block_id_at(pos: Vector2)-> int:
	return get_block_id(get_tile(pos))


func get_tile(pos: Vector2)-> Vector2i:
	var chunk: WorldChunk= get_chunk_at(pos / WorldChunk.SIZE)
	if not chunk: 
		assert(false)
		return Vector2i.ZERO
	return chunk.local_to_map(pos)


func get_chunk_at(tile_pos: Vector2i)-> WorldChunk:
	tile_pos= (Vector2(tile_pos) / WorldChunk.SIZE).floor()
	var key: String= str(tile_pos)
	var node: Node= chunks.get_node_or_null(key)
	return node


func map_to_local(tile_pos: Vector2i)-> Vector2:
	return tile_pos * TILE_SIZE + Vector2i.ONE * TILE_SIZE / 2


func get_block_hardness(tile_pos: Vector2i)-> float:
	var block: Block= get_block(tile_pos)
	if not block:
		return 0.0
	return block.hardness


func break_block(tile_pos: Vector2i):
	var chunk: WorldChunk= get_chunk_at(tile_pos)
	if not chunk: 
		assert(false)
		return null
	chunk.break_block(tile_pos)


func spawn_item(item: Item, pos: Vector2)-> WorldItem:
	var world_item: WorldItem= world_item_scene.instantiate()
	world_item.position= pos
	add_child(world_item)
	
	world_item.item= item
	return world_item


func throw_item(item: Item, pos: Vector2, velocity: Vector2):
	spawn_item(item, pos).velocity= velocity


func spawn_block_entity(tile_pos: Vector2i, entity_scene: PackedScene):
	var entity: BaseBlockEntity= entity_scene.instantiate()
	entity.position= tile_pos * TILE_SIZE
	add_child(entity)
	
	if entity.register_tick:
		tick_entities.append(entity)
