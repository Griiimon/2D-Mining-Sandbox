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
	
	var neighbor_positions: Array[Vector2i]
	var left_right:= [-1, 1]
	left_right.shuffle()
	neighbor_positions.append(block_pos + Vector2i.DOWN)
	for y in range(1, -1, -1):
			for i in 2:
				neighbor_positions.append(Vector2i(left_right[i], y) + block_pos)
		
	for pos in neighbor_positions:
		var neighbor_block: Block= world.get_block(pos)
		if neighbor_block is FluidBlock:
			if not (neighbor_block as FluidBlock).is_full() and DataManager.fluid_library.is_same_fluid(self, neighbor_block):
				#if not flow(world, block_pos, below_pos, block_below):
				flow(world, block_pos, pos, neighbor_block)
				return
	
	if can_split():
		var potential_split_pos: Array[Vector2i]= []
		for x in [-1, 1]:
			var pos: Vector2i= block_pos + Vector2i(x, 0)
			if world.is_air_at(pos):
				potential_split_pos.append(pos)
		
		if not potential_split_pos.is_empty():
			var split_product: Block= get_split_block(len(potential_split_pos))
			if split_product:
				for pos in potential_split_pos:
					world.set_block(split_product, pos)
					(world.get_block(pos) as FluidBlock).finalize(world, pos)
				
				replace(world, block_pos, get_split_block())
				finalize(world, block_pos)
				return
	
	NodeDebugger.write(world, str("water block cant split ", block_pos), 4)
	
	if not finalize(world, block_pos):
		world.unschedule_block(block_pos)
		pass

func finalize(world: World, block_pos: Vector2i)-> bool:
	if is_full(): return false
	
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
		world.schedule_block(block_pos)
	return make_flow


func flow(world: World, block_pos: Vector2i, below_pos: Vector2i, block_below: FluidBlock)-> bool:
	var new_block: Block= DataManager.fluid_library.get_lower_fluid_block(self)
	replace(world, block_pos, new_block)
	if not world.is_air_at(block_pos):
		(world.get_block(block_pos) as FluidBlock).finalize(world, block_pos)
	replace(world, below_pos, DataManager.fluid_library.get_higher_fluid_block(block_below))
	world.schedule_block(below_pos)
	(world.get_block(below_pos) as FluidBlock).finalize(world, below_pos)
	return new_block != null


func on_neighbor_update(world: World, block_pos: Vector2i, neighbor_pos: Vector2i):
	#if neighbor_pos.y >= block_pos.y:
	world.schedule_block(block_pos)


func can_split()-> bool:
	return not is_flowing and get_split_block() != null


func get_split_block(depth: int= 1)-> Block:
	return DataManager.fluid_library.get_split_block(self, depth)


func is_full()-> bool:
	return fill_ratio == FillRatio.FULL
