class_name TerrainGeneratorInstruction
extends Resource

@export var top_down: bool= false
@export var min_height: int= 0
@export var max_height: int= 1024
@export var distribution: TerrainBlockDistribution
@export var is_cave: bool= false
@export var ignore_height: bool= false
@export var height_curve: Curve


var generator: TerrainGenerator
var instruction: TerrainGeneratorInstruction



func initialize(_generator: TerrainGenerator):
	generator= _generator
	distribution.initialize()


func get_block(pos: Vector2i)-> Block:
	if not top_down:
		if pos.y < min_height or pos.y > max_height:
			return null
		if not ignore_height and pos.y < generator.get_height(pos.x):
			return null
		if height_curve:
			var height: float= pos.y - generator.get_height(pos.x)
			var mapped: float= remap(height, 0, max_height - min_height, 0, 1)
			height= height_curve.sample_baked(mapped)
			height= clamp(height, 0.0, 0.99)
			return distribution.blocks[round(lerp(0, len(distribution.blocks) - 1, height))]
	return distribution.get_block(pos)
