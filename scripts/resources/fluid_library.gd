class_name FluidLibrary
extends Resource


@export var fluids: Array[FluidLibraryItem]


var block_to_fluid:= {}


func build():
	for fluid in fluids:
		for block in fluid.blocks:
			block_to_fluid[block]= fluid


func is_same_fluid(block1: Block, block2: Block)-> bool:
	return get_fluid(block1) == get_fluid(block2)


func get_lower_fluid_block(block: Block)-> Block:
	var fluid: FluidLibraryItem= get_fluid(block)
	var idx: int= fluid.blocks.find(block)
	if idx == len(fluid.blocks) - 1:
		return null
	return fluid.blocks[idx + 1]


func get_fluid(block: Block)-> FluidLibraryItem:
	return block_to_fluid[block]
