class_name Game
extends Node

@onready var world: World = $TileMap


func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
