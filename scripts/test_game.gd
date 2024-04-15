extends Game


func _ready():
	super()
	world.spawn_block_entity(Vector2i(-7, 6), load("res://scenes/block entities/furnace.tscn"))
	for x in 4:
		world.set_block(Vector2i(x, 6), load("res://resources/blocks/water_block.tres"))
