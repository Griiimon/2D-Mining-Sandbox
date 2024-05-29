extends Block
class_name GrassBlock

@export var dirt: Block



func on_neighbor_update(world: World, block_pos: Vector2i, _neighbor_pos: Vector2i):
	run_check(world, block_pos)


func on_chunk_generated(world: World, block_pos: Vector2i):
	run_check(world, block_pos)


func on_random_update(world: World, block_pos: Vector2i):
	run_check(world, block_pos)


func run_check(world: World, block_pos: Vector2i):
	if world.has_block_above(block_pos):
		replace(world, block_pos, dirt)

