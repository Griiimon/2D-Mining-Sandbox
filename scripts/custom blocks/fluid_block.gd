class_name FluidBlock
extends Block


@export var fill_ratio: float= 1.0


func on_tick(world: World, block_pos: Vector2i):
	if world.is_air_at(block_pos + Vector2i.DOWN):
		move(world, block_pos, Vector2i.DOWN)
		return
	
	# TODO check fluid block below with fill < 1
	
	if can_split():
		var potential_split_pos: Array[Vector2i]
		for x in [-1, 1]:
			var pos: Vector2i= block_pos + Vector2i(x, 0)
			if world.is_air_at(pos):
				potential_split_pos.append(pos)
		
		if not potential_split_pos.is_empty():
			var split_product: Block= get_split_block(len(potential_split_pos))
			
			for pos in potential_split_pos:
				world.set_block(pos, split_product)
			
			replace(world, block_pos, get_split_block())
			
			return
	
	NodeDebugger.msg(world, str("water block cant split ", block_pos), 4)
	
	world.unschedule_block(block_pos)


func on_neighbor_update(world: World, block_pos: Vector2i, neighbor_pos: Vector2i):
	#if neighbor_pos.y >= block_pos.y:
	world.schedule_block(block_pos)


func can_split()-> bool:
	return get_split_block(1) != null


func get_split_block(depth: int= 1)-> Block:
	return DataManager.fluid_library.get_lower_fluid_block(self, depth)
