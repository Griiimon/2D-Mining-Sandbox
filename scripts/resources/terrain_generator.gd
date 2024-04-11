class_name TerrainGenerator
extends Resource

@export var instructions: Array[TerrainGeneratorInstruction]

var sorted_instructions: Array[TerrainGeneratorInstruction]


func initialize():
	sort_instructions()


func sort_instructions():
	sorted_instructions= instructions.duplicate()


func get_block_id(pos: Vector2i)-> int:
	var block: Block

	for instruction in instructions:
		block= instruction.get_block(pos)

	if not block: return -1
	return DataManager.blocks.find(block)
