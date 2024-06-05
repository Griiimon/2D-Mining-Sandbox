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
	
	var neighbor_positions: Array[Vector2i]= []
	var left_right:= [-1, 1]
	left_right.shuffle()
	neighbor_positions.append(block_pos + Vector2i.DOWN)
	for y in range(1, -1, -1):
			for i in 2:
				neighbor_positions.append(Vector2i(left_right[i], y) + block_pos)
		
	for pos in neighbor_positions:
		var neighbor_block: Block= world.get_block(pos)
		if not neighbor_block or neighbor_block is FluidBlock:
			if not neighbor_block or (not (neighbor_block as FluidBlock).is_full() and DataManager.fluid_library.is_same_fluid(self, neighbor_block)):
				if neighbor_block and block_pos.y == pos.y and (neighbor_block as FluidBlock).fill_ratio < fill_ratio: continue
				flow(world, block_pos, pos, neighbor_block)
				return
	
	
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


func flow(world: World, block_pos: Vector2i, neighbor_pos: Vector2i, neighbor_block: FluidBlock):
	var new_block: Block= DataManager.fluid_library.get_lower_fluid_block(self)
	replace(world, block_pos, new_block)

	if not world.is_air_at(block_pos):
		(world.get_block(block_pos) as FluidBlock).finalize(world, block_pos)

	if not neighbor_block:
		replace(world, neighbor_pos, DataManager.fluid_library.get_fluid(self).blocks[-1])
	else:
		replace(world, neighbor_pos, DataManager.fluid_library.get_higher_fluid_block(neighbor_block))

	world.schedule_block(neighbor_pos)
	(world.get_block(neighbor_pos) as FluidBlock).finalize(world, neighbor_pos)


func on_neighbor_update(world: World, block_pos: Vector2i, _neighbor_pos: Vector2i):
	#if neighbor_pos.y >= block_pos.y:
	world.schedule_block(block_pos)


func can_split()-> bool:
	return not is_flowing and get_split_block() != null


func get_split_block(depth: int= 1)-> Block:
	return DataManager.fluid_library.get_split_block(self, depth)


func is_full()-> bool:
	return fill_ratio == FillRatio.FULL
