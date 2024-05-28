class_name FluidBlock
extends Block

enum FillRatio { FULL, THREE_QUARTER, HALF, QUARTER }

@export var fill_ratio: FillRatio
@export var is_flowing: bool= false


func on_tick(world: World, block_pos: Vector2i):
	if world.is_air_at(block_pos + Vector2i.DOWN):
		move(world, block_pos, Vector2i.DOWN)
		finalize(world, block_pos)
		return
	
	var block_below: Block= world.get_block(block_pos + Vector2i.DOWN)
	
	if block_below is FluidBlock:
		if not (block_below as FluidBlock).is_full() and DataManager.fluid_library.is_same_fluid(self, block_below):
			flow(world, block_pos, block_below)
			finalize(world, block_pos)
			return
	
	if can_split():
		var potential_split_pos: Array[Vector2i]= []
		for x in [-1, 1]:
			var pos: Vector2i= block_pos + Vector2i(x, 0)
			if world.is_air_at(pos):
				potential_split_pos.append(pos)
		
		if not potential_split_pos.is_empty():
			var split_product: Block= get_split_block(len(potential_split_pos))
			
			for pos in potential_split_pos:
				world.set_block(split_product, pos)
			
			replace(world, block_pos, get_split_block())
			finalize(world, block_pos)
			return
	
	NodeDebugger.write(world, str("water block cant split ", block_pos), 4)
	
	world.unschedule_block(block_pos)
	finalize(world, block_pos)


func finalize(world: World, block_pos: Vector2i):
	if is_full(): return
	
	var make_flow:= false
	
	var block_above: Block= world.get_block(block_pos + Vector2i.UP)
	if block_above and block_above is FluidBlock:
		if not is_flowing:
			make_flow= true
	
	if not make_flow:
		var block_below: Block= world.get_block(block_pos + Vector2i.DOWN)
		if block_below:
			if block_below is FluidBlock:
				if not block_below.is_full():
					make_flow= true
		else:
			make_flow= true
	
	if make_flow:
		replace(world, block_pos, DataManager.fluid_library.get_flowing_block(self))


func on_neighbor_update(world: World, block_pos: Vector2i, neighbor_pos: Vector2i):
	if neighbor_pos.y >= block_pos.y:
		world.schedule_block(block_pos)


func flow(world: World, block_pos: Vector2i, block_below: FluidBlock):
	replace(world, block_pos, DataManager.fluid_library.get_lower_fluid_block(self))
	replace(world, block_pos + Vector2i.DOWN, DataManager.fluid_library.get_higher_fluid_block(block_below))


func can_split()-> bool:
	return get_split_block(1) != null


func get_split_block(depth: int= 1)-> Block:
	return DataManager.fluid_library.get_split_block(self, depth)


func is_full()-> bool:
	return fill_ratio == FillRatio.FULL
