extends Game


func _ready():
	super()
	#world.spawn_block_entity(DataManager.block_entities[0], Vector2i(-7, 6))


func post_init():
	world.set_block(load("res://game/blocks/water blocks/water_source_block.tres"), Vector2i(0, -2))
	
	return
	
	var water_block: Block= load("res://game/blocks/water blocks/water_block.tres")
	var y:= 8
	for x in 12:
		world.delete_block(Vector2i(x, y - 1), false)
		world.set_block(water_block, Vector2i(x, y), Block.State.NONE, false)
		if x > 3:
			world.set_block(water_block, Vector2i(x, y + 1), Block.State.NONE, false)
			if x > 6:
				world.set_block(water_block, Vector2i(x, y + 2), Block.State.NONE, false)


func _physics_process(delta):
	DebugHud.send("Scheduled", world.get_chunks().reduce(func(sum, c: WorldChunk): return sum + len(c.scheduled_blocks), 0))
	
	for chunk in world.get_chunks():
		for pos in chunk.scheduled_blocks:
			DebugHud.add_global_label(world.map_to_local(chunk.get_global_pos(pos)) - Vector2.ONE * World.TILE_SIZE / 2, "S", 0.1)
