extends Game


func _ready():
	super()
	world.spawn_block_entity(Vector2i(2, 4), load("res://scenes/block entities/furnace.tscn"))
