class_name World
extends TileMap

const TILE_SIZE= 32



func get_block_id_at(pos: Vector2)-> int:
	var tile_pos: Vector2i= get_tile(pos)
	if not tile_pos in get_used_cells(0):
		return -1
	return get_cell_source_id(0, tile_pos)


func get_tile(pos: Vector2)-> Vector2i:
	return local_to_map(pos)


func get_block_hardness(tile_pos: Vector2i)-> float:
	return 1.0


func break_block(tile_pos: Vector2i):
	set_cell(0, tile_pos, -1)
