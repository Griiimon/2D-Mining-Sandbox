class_name World
extends TileMap

const TILE_SIZE= 32

@export var world_item_scene: PackedScene

# creates a tile-set automatically from block textures
func _ready():
	var collision_polygon:= [Vector2(0, 0), Vector2(TILE_SIZE, 0), Vector2(TILE_SIZE, TILE_SIZE),  Vector2(0, TILE_SIZE)]

	for i in collision_polygon.size():
		collision_polygon[i]= collision_polygon[i] - Vector2.ONE * TILE_SIZE / 2

	for block in DataManager.blocks:
		var source:= TileSetAtlasSource.new()
		source.texture_region_size= Vector2i.ONE * TILE_SIZE
		source.texture= block.texture
		source.create_tile(Vector2i.ZERO)
		tile_set.add_source(source)
		
		if block.has_collision:
			var tile_data: TileData= source.get_tile_data(Vector2i.ZERO, 0)
			tile_data.add_collision_polygon(0)
			tile_data.set_collision_polygon_points(0, 0, collision_polygon)


func get_block(tile_pos: Vector2i)-> Block:
	var block_id: int= get_block_id(tile_pos)
	if block_id == -1:
		return null
	return DataManager.blocks[block_id]

func get_block_id_at(pos: Vector2)-> int:
	return get_block_id(get_tile(pos))


func get_block_id(tile_pos: Vector2i)-> int:
	if not tile_pos in get_used_cells(0):
		return -1
	return get_cell_source_id(0, tile_pos)


func get_tile(pos: Vector2)-> Vector2i:
	return local_to_map(pos)


func get_block_hardness(tile_pos: Vector2i)-> float:
	var block: Block= get_block(tile_pos)
	if not block:
		return 0.0
	return block.hardness


func break_block(tile_pos: Vector2i):
	var block_id: int= get_block_id(tile_pos)
	if block_id >= 0:
		var block: Block= DataManager.blocks[block_id]
		if block.drop:
			spawn_item(block.drop, map_to_local(tile_pos))
		set_cell(0, tile_pos, -1)


func spawn_item(item: Item, pos: Vector2)-> WorldItem:
	var world_item: WorldItem= world_item_scene.instantiate()
	world_item.position= pos
	add_child(world_item)
	
	world_item.item= item
	return world_item


func throw_item(item: Item, pos: Vector2, velocity: Vector2):
	spawn_item(item, pos).velocity= velocity
	
