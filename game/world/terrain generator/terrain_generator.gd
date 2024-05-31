class_name TerrainGenerator
extends Resource

@export var instructions: Array[TerrainGeneratorInstruction]
@export var height_noise: FastNoiseLite
@export var height_scale: float= 10.0


var cave_cache: Array[Vector2i]



func initialize():
	for instruction in instructions:
		instruction.initialize(self)


func get_block_id(pos: Vector2i)-> int:
	var block: Block

	var cave:= false
	
	for instruction in instructions:
		var new_block: Block= instruction.get_block(pos)
		if new_block:
			cave= new_block.is_air and instruction.is_cave
		block= new_block if new_block else block

	if cave:
		cave_cache.append(pos)

	if not block or block.is_air: return -1
	return DataManager.get_block_id(block)


func start_caching_caves():
	cave_cache= []


func is_cave(pos: Vector2i)-> bool:
	return pos in cave_cache


func get_height(x: int)-> int:
	if not height_noise: return 999999
	return int(height_noise.get_noise_1d(x) * height_scale)
