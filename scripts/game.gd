class_name Game
extends Node

@onready var world: World = $TileMap




func _ready():
	world.spawn_block_entity(Vector2i(2, 4), load("res://scenes/block entities/furnace.tscn"))


func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
