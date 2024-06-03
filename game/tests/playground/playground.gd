extends Game



func _ready():
	super()
	world.spawn_block_entity(DataManager.block_entities[0], Vector2i(-7, 6))


func post_init():
	var water_block: Block= load("res://game/blocks/water blocks/water_block.tres")
	var y:= 8
	for x in 12:
		#DebugHud.add_global_label(world.map_to_local(Vector2i(x, y - 1)), "X")
		world.delete_block(Vector2i(x, y - 1), false)
		world.set_block(water_block, Vector2i(x, y), Block.State.NONE, false)
		if x > 3:
			world.set_block(water_block, Vector2i(x, y + 1), Block.State.NONE, false)
			if x > 6:
				world.set_block(water_block, Vector2i(x, y + 2), Block.State.NONE, false)
