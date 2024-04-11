class_name TerrainBlockDistribution
extends Resource

@export var blocks: Array[Block]
@export var noise: FastNoiseLite



func get_block(pos: Vector2i)-> Block:
	if not noise:
		return blocks[0]
	return null
