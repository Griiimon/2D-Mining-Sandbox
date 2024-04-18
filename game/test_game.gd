extends Game


func _ready():
	super()
	world.spawn_block_entity(Vector2i(-7, 6), load("res://scenes/block entities/furnace.tscn"))


func post_init():
	var water_block: Block= load("res://resources/blocks/water_block.tres")
	var y:= 8
	for x in 12:
		world.delete_block(Vector2i(x, y - 1), false)
		world.set_block(Vector2i(x, y), water_block, false)
		if x > 3:
			world.set_block(Vector2i(x, y + 1), water_block, false)
			if x > 6:
				world.set_block(Vector2i(x, y + 2), water_block, false)
