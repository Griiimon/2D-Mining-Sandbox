extends Node

@export var skip_main_menu: bool= false
@export var skip_to_scene: PackedScene
@export var main_menu: PackedScene



func _ready():
	assert(main_menu)
	assert(not skip_main_menu or skip_to_scene != null)
	
	if skip_main_menu:
		GameManager.run_game(skip_to_scene)
	else:
		get_tree().change_scene_to_packed(main_menu)
