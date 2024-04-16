extends Game


func _ready():
	super()
	world.spawn_block_entity(Vector2i(-7, 6), load("res://scenes/block entities/furnace.tscn"))


func post_init():
		var y:= 8
		for x in 12:
			world.set_block(Vector2i(x, y - 1), load("res://resources/blocks/air_block.tres"), false)
			world.set_block(Vector2i(x, y), load("res://resources/blocks/water_block.tres"), false)
			if x > 3:
				world.set_block(Vector2i(x, y + 1), load("res://resources/blocks/water_block.tres"), false)
				if x > 6:
					world.set_block(Vector2i(x, y + 2), load("res://resources/blocks/water_block.tres"), false)
