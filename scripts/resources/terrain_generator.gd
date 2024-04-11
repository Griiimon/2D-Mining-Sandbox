class_name TerrainGenerator
extends Resource

@export var instructions: Array[TerrainGeneratorInstruction]

var sorted_instructions: Array[TerrainGeneratorInstruction]


func initialize():
	sort_instructions()
	for instruction in sorted_instructions:
		instruction.initialize()


func sort_instructions():
	var tmp_instructions:= instructions.duplicate()
	
	while tmp_instructions:
		var result: TerrainGeneratorInstruction
		for instruction in tmp_instructions:
			if not result or instruction.priority > result.priority:
				result= instruction
		sorted_instructions.append(result)
		tmp_instructions.erase(result)


func get_block_id(pos: Vector2i)-> int:
	var block: Block

	for instruction in instructions:
		var new_block: Block= instruction.get_block(pos)
		block= new_block if new_block else block

	if not block or block.is_air: return -1
	return DataManager.blocks.find(block)
