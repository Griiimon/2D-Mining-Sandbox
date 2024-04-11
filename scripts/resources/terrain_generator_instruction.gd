class_name TerrainGeneratorInstruction
extends Resource

@export var priority: int= 0
@export var min_height: int= 0
@export var max_height: int= 1024
@export var distribution: TerrainBlockDistribution



func get_block(pos: Vector2i)-> Block:
	if pos.y < min_height or pos.y > max_height:
		return null
	return distribution.get_block(pos)
