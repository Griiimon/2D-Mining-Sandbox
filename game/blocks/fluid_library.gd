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


func get_lower_fluid_block(block: FluidBlock, depth: int= 1)-> FluidBlock:
	var fluid: FluidLibraryItem= get_fluid(block)
	var idx: int= fluid.blocks.find(block)
	if idx >= len(fluid.blocks) - depth:
		return null
	return fluid.blocks[idx + depth]


func get_split_block(block: FluidBlock, depth: int= 1)-> FluidBlock:
	if block.fill_ratio == FluidBlock.FillRatio.FULL:
		depth+= 1
	return get_lower_fluid_block(block, depth)


func get_fluid(block: Block)-> FluidLibraryItem:
	return block_to_fluid[block]
