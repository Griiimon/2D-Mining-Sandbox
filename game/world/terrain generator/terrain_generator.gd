class_name TerrainGenerator
extends Resource

@export var instructions: Array[TerrainGeneratorInstruction]



func initialize():
	for instruction in instructions:
		instruction.initialize()


func get_block_id(pos: Vector2i)-> int:
	var block: Block

	for instruction in instructions:
		var new_block: Block= instruction.get_block(pos)
		block= new_block if new_block else block

	if not block or block.is_air: return -1
	return DataManager.get_block_id(block)
