class_name World
extends Node2D

signal initialization_finished

const ENTITY_TICKS= 60

const TILE_SIZE= 32

@export var world_item_scene: PackedScene
@export var world_chunk_scene: PackedScene
@export var chunks: Node2D
@export var generator: TerrainGenerator

var tick_entities: Array[BaseBlockEntity]


func _ready():
	if generator:
		generator.initialize()
		

func _physics_process(_delta):
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
	var chunk: WorldChunk= get_chunk_at((pos / WorldChunk.SIZE).floor())
	if not chunk: 
		assert(false)
		return Vector2i.ZERO
	DebugHud.send("get_tile() chunk", str(chunk.coords))
	return chunk.local_to_map(pos)


func get_chunk_coords_at(tile_pos: Vector2i)-> Vector2i:
	return (Vector2(tile_pos) / WorldChunk.SIZE).floor()


func get_chunk_at(tile_pos: Vector2i)-> WorldChunk:
	return get_chunk(get_chunk_coords_at(tile_pos))


func get_chunk(chunk_coords: Vector2i)-> WorldChunk:
	var key: String= str(chunk_coords)
	var node: Node= chunks.get_node_or_null(key)
	return node
	

func get_chunks()-> Array[WorldChunk]:
	var result: Array[WorldChunk]= []
	result.assign(chunks.get_children())
	return result


func create_chunk(chunk_coords: Vector2i):
	var chunk: WorldChunk= world_chunk_scene.instantiate()
	chunk.name= str(chunk_coords)
	chunk.position= chunk_coords * WorldChunk.SIZE * TILE_SIZE
	chunks.add_child(chunk)
	chunk.coords= chunk_coords
	chunk.generate_tiles()


func map_to_local(tile_pos: Vector2i)-> Vector2:
	return tile_pos * TILE_SIZE + Vector2i.ONE * TILE_SIZE / 2


func get_block_hardness(tile_pos: Vector2i)-> float:
	var block: Block= get_block(tile_pos)
	if not block:
		return 0.0
	return block.hardness


func delete_block(tile_pos: Vector2i):
	var chunk: WorldChunk= get_chunk_at(tile_pos)
	if not chunk: 
		assert(false)
		return null
	chunk.delete_block(tile_pos)


func break_block(tile_pos: Vector2i, with_drops: bool= true):
	var chunk: WorldChunk= get_chunk_at(tile_pos)
	if not chunk: 
		assert(false)
		return null
	chunk.break_block(tile_pos, with_drops)
	

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


func _on_chunk_updater_initial_run_completed():
	var settings: GameSettings= Global.game.settings
	for x in range(-settings.spawn_clearing_radius, settings.spawn_clearing_radius):
		for y in range(-settings.spawn_clearing_radius, settings.spawn_clearing_radius):
			delete_block(settings.player_spawn + Vector2i(x, y))

	initialization_finished.emit()
