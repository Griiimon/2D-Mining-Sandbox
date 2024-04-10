class_name TerrainGenerator
extends Resource

@export var instructions: Array[TerrainGeneratorInstruction]

var sorted_instructions: Array[TerrainGeneratorInstruction]


func sort_instructions():
	sorted_instructions= instructions.duplicate()
