class_name WorldChunk
extends TileMap

const SIZE= 32

@export var coords: Vector2i
@export var auto_generate_tiles: bool= true

var world: World



func _ready():
	world= get_parent().get_parent()

	tile_set= DataManager.tile_set
	
	if auto_generate_tiles:
		generate_tiles()



func generate_tiles():
	for x in SIZE:
		for y in SIZE:
			set_cell(0, Vector2i(x, y), 0, Vector2i.ZERO)
	print(get_used_rect())

func _tile_data_runtime_update(layer, coords, tile_data):
	pass


func _use_tile_data_runtime_update(layer, coords):
	return Engine.is_editor_hint()


func get_block_id(tile_pos: Vector2i)-> int:
	tile_pos= make_tile_pos_local(tile_pos)
	if not tile_pos in get_used_cells(0):
		return -1
	return get_cell_source_id(0, tile_pos)


func make_tile_pos_local(tile_pos: Vector2i)-> Vector2i:
	return tile_pos 


func break_block(tile_pos: Vector2i):
	var block_id: int= get_block_id(tile_pos)
	if block_id >= 0:
		var block: Block= DataManager.blocks[block_id]
		var world_pos: Vector2= map_to_local(tile_pos)
		if block.drop:
			world.spawn_item(block.drop, world_pos)
		set_cell(0, tile_pos, -1)

		Effects.spawn_particle_system(world_pos, MyParticleSystem.ParticleSettings.new(20, 3, block.particle_color, 1, 1, 2, true, 50, 100, 500, Vector2.UP, 90, true, 0.5, 0))


func get_world_tile_pos()-> Vector2i:
	return coords * SIZE


func get_world_tile_pos_center()-> Vector2i:
	return coords * SIZE + Vector2i.ONE * SIZE / 2


# creates a tile-set automatically from block textures
static func create_tileset():
	DataManager.tile_set= load(DataManager.ORIG_TILE_SET_PATH).duplicate()

	var collision_polygon:= [Vector2(0, 0), Vector2(World.TILE_SIZE, 0), Vector2(World.TILE_SIZE, World.TILE_SIZE),  Vector2(0, World.TILE_SIZE)]

	for i in collision_polygon.size():
		collision_polygon[i]= collision_polygon[i] - Vector2.ONE * World.TILE_SIZE / 2

	for block in DataManager.blocks:
		var source:= TileSetAtlasSource.new()
		source.texture_region_size= Vector2i.ONE * World.TILE_SIZE
		source.texture= block.texture
		source.create_tile(Vector2i.ZERO)
		DataManager.tile_set.add_source(source)
		
		if block.has_collision:
			var tile_data: TileData= source.get_tile_data(Vector2i.ZERO, 0)
			tile_data.add_collision_polygon(0)
			tile_data.set_collision_polygon_points(0, 0, collision_polygon)


	ResourceSaver.save(DataManager.tile_set, DataManager.TILE_SET_PATH)