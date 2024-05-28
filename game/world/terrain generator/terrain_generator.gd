class_name TerrainGenerator
extends Resource

@export var instructions: Array[TerrainGeneratorInstruction]
@export var height_noise: FastNoiseLite
@export var height_scale: float= 10.0



func initialize():
	for instruction in instructions:
		instruction.initialize(self)


func get_block_id(pos: Vector2i)-> int:
	var block: Block

	for instruction in instructions:
		var new_block: Block= instruction.get_block(pos)
		block= new_block if new_block else block

	if not block or block.is_air: return -1
	return DataManager.get_block_id(block)


func get_height(x: int)-> int:
	if not height_noise: return 999999
	return height_noise.get_noise_1d(x) * height_scale
