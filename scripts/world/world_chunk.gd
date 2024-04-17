class_name WorldChunk
extends TileMap

const SIZE= 32

@export var coords: Vector2i
@export var auto_generate_tiles: bool= true

@export var block_break_particles: ParticleSettings

var world: World

var scheduled_blocks: Array[Vector2i]= []

var items: Array[WorldItem]= []

var has_changes: bool= false: set= set_changes

var ignore_changes: bool= true



func _ready():
	world= get_parent().get_parent()

	tile_set= DataManager.tile_set
	
	if auto_generate_tiles:
		generate_tiles()

	var rect: Rect2i= get_used_rect()
	assert(rect.position.x >= 0 and rect.position.y >= 0 and rect.size.x < SIZE and rect.size.y < SIZE)


func generate_tiles():
	assert(ignore_changes)
	var generator: TerrainGenerator= world.generator
	for x in SIZE:
		for y in SIZE:
			var local_pos= Vector2i(x, y)
			var global_pos= get_global_pos(local_pos)
			var block_id: int= generator.get_block_id(global_pos)
			var block: Block= DataManager.get_block(block_id)
			set_block(local_pos, block, false)
	ignore_changes= false


func tick_blocks():
	for block_pos in scheduled_blocks.duplicate():
		var block: Block= get_block(block_pos)
		if block:
			block.on_tick(world, get_global_pos(block_pos))
		else:
			assert(false)
			# TODO i would like to store a failed attempt and only 
			# unschedule after a second failed attempt ( additional array )
			unschedule_block(block_pos)


func set_block(tile_pos: Vector2i, block: Block, trigger_neighbor_update: bool= true):
	if not block:
		delete_block(tile_pos, trigger_neighbor_update)
		return

	var block_id: int= DataManager.get_block_id(block)

	tile_pos= get_local_pos(tile_pos)
	set_cell(0, tile_pos, block_id, Vector2i.ZERO)
	if block.is_fluid:
		set_cell(1, tile_pos, block_id, Vector2i.ZERO)
	block.on_spawn(world, get_global_pos(tile_pos))
	if block.schedule_tick:
		scheduled_blocks.append(tile_pos)
	
	if trigger_neighbor_update:
		world.trigger_neighbor_update(get_global_pos(tile_pos))
	has_changes= true


func delete_block(tile_pos: Vector2i, trigger_neighbor_update: bool= true):
	set_cell(0, get_local_pos(tile_pos), -1)
	set_cell(1, get_local_pos(tile_pos), -1)
	scheduled_blocks.erase(tile_pos)
	
	if trigger_neighbor_update:
		world.trigger_neighbor_update(get_global_pos(tile_pos))
	has_changes= true


func get_block(tile_pos: Vector2i)-> Block:
	var block_id: int= get_block_id(tile_pos)
	if block_id == -1:
		return null
	return DataManager.get_block(block_id)


func _tile_data_runtime_update(_layer, _coords, _tile_data):
	pass


func _use_tile_data_runtime_update(_layer, _coords):
	return Engine.is_editor_hint()


func get_block_id(tile_pos: Vector2i)-> int:
	tile_pos= get_local_pos(tile_pos)
	if not tile_pos in get_used_cells(0):
		return -1
	return get_cell_source_id(0, tile_pos)


func get_local_pos(tile_pos: Vector2i)-> Vector2i:
	return Vector2i(wrapi(tile_pos.x, 0, SIZE), wrapi(tile_pos.y, 0, SIZE))


func get_global_pos(tile_pos: Vector2i)-> Vector2i:
	return  tile_pos + coords * SIZE


func break_block(tile_pos: Vector2i, with_drops: bool= true):
	var block_id: int= get_block_id(tile_pos)
	if block_id >= 0:
		var block: Block= DataManager.blocks[block_id]
		var world_pos: Vector2= map_to_local(tile_pos)
		if with_drops and block.drop:
			world.spawn_item(block.drop, world_pos)
		delete_block(get_local_pos(tile_pos))

		Effects.spawn_particle_system(world_pos, block_break_particles.duplicate().set_color(block.particle_color))
		block.on_break(world, tile_pos)


func schedule_block(tile_pos: Vector2i):
	tile_pos= get_local_pos(tile_pos)
	if not tile_pos in scheduled_blocks:
		scheduled_blocks.append(tile_pos)


func unschedule_block(tile_pos: Vector2i):
	tile_pos= get_local_pos(tile_pos)
	scheduled_blocks.erase(tile_pos)


func get_world_tile_pos()-> Vector2i:
	return coords * SIZE


func get_world_tile_pos_center()-> Vector2i:
	return coords * SIZE + Vector2i.ONE * SIZE / 2


func save()-> ChunkStorage:
	var storage:= ChunkStorage.new()
	for x in SIZE:
		for y in SIZE:
			storage.tiles.append(get_block_id(Vector2i(x, y)))
	return storage


func restore(storage: ChunkStorage):
	ignore_changes= true
	var tiles: Array[int]= storage.tiles.duplicate()
	for x in SIZE:
		for y in SIZE:
			set_block(Vector2i(x, y), DataManager.get_block(tiles.pop_front()), false)
	ignore_changes= false


func cleanup():
	for item in items:
		if is_instance_valid(item):
			item.queue_free()
	items.clear()


func set_changes(b: bool):
	if not b:
		has_changes= false
		return
	if not ignore_changes:
		has_changes= b


# creates a tile-set automatically from block textures
static func create_tileset():
	DataManager.tile_set= load(DataManager.ORIG_TILE_SET_PATH).duplicate()

	var collision_polygon:= [Vector2(0, 0), Vector2(World.TILE_SIZE, 0), Vector2(World.TILE_SIZE, World.TILE_SIZE),  Vector2(0, World.TILE_SIZE)]

	for i in collision_polygon.size():
		collision_polygon[i]= collision_polygon[i] - Vector2.ONE * World.TILE_SIZE / 2

	for block in DataManager.blocks:
		var source:= TileSetAtlasSource.new()
		if not block.is_air:
			source.texture_region_size= Vector2i.ONE * World.TILE_SIZE
			source.texture= block.texture
			source.create_tile(Vector2i.ZERO)
		DataManager.tile_set.add_source(source)
		
		if block.has_collision:
			var tile_data: TileData= source.get_tile_data(Vector2i.ZERO, 0)
			tile_data.add_collision_polygon(0)
			tile_data.set_collision_polygon_points(0, 0, collision_polygon)


	ResourceSaver.save(DataManager.tile_set, DataManager.TILE_SET_PATH)
