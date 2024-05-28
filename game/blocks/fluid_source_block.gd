class_name FluidSourceBlock
extends Block

@export var fluid: FluidLibraryItem


func on_tick(world: World, block_pos: Vector2i):
	if world.is_air_at(block_pos + Vector2i.DOWN):
		world.set_block(fluid.blocks[0], block_pos + Vector2i.DOWN)
