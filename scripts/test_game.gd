extends Game


func _ready():
	super()
	world.spawn_block_entity(Vector2i(-7, 6), load("res://scenes/block entities/furnace.tscn"))
