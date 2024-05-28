class_name TerrainGeneratorInstruction
extends Resource

@export var min_height: int= 0
@export var max_height: int= 1024
@export var distribution: TerrainBlockDistribution
@export var ignore_height: bool= false


var generator: TerrainGenerator
var instruction: TerrainGeneratorInstruction



func initialize(_generator: TerrainGenerator):
	generator= _generator
	distribution.initialize()


func get_block(pos: Vector2i)-> Block:
	if pos.y < min_height or pos.y > max_height:
		return null
	if not ignore_height and pos.y < generator.get_height(pos.x):
		return null
	return distribution.get_block(pos)
