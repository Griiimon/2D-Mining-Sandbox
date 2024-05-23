extends Node

const RESOURCE_PATH= "res://local/game_start.res"

@export_group("Functionality moved to")
@export_placeholder(RESOURCE_PATH) var _look_here: String

@export_category("Scenes")
@export var main_menu: PackedScene


@onready var game_over_container = $"Game Over CenterContainer"
@onready var game_over_label = %"Game Over Label"


var game: Game
var character: PackedScene
var world_seed: String

var game_start_resource: GameStart


func init():
	if not ResourceLoader.exists(RESOURCE_PATH):
		game_start_resource= GameStart.new()
		ResourceSaver.save(game_start_resource, RESOURCE_PATH)
	else:
		game_start_resource= load(RESOURCE_PATH)

	assert(main_menu)
	assert(not game_start_resource.skip_main_menu or game_start_resource.skip_to_scene != null)
	
	if game_start_resource.skip_main_menu:
		GameManager.run_game(game_start_resource.skip_to_scene)
	else:
		get_tree().change_scene_to_packed.call_deferred(main_menu)


func _unhandled_key_input(event):
	var key_event: InputEventKey= event
	if key_event.is_pressed() and key_event.keycode == KEY_ESCAPE:
		if is_ingame():
			load_main_menu()
		else:
			get_tree().quit()


func run_game(scene: PackedScene):
	run_deferred.call_deferred(scene)


func run_deferred(scene: PackedScene):
	assert(get_tree().change_scene_to_packed(scene) == OK)


func game_over(win: bool):
	get_tree().paused= true
	game_over_label.text= "You won!!" if win else "You lost :("
	game_over_container.show()


func _on_try_again_button_pressed():
	game_over_container.hide()
	get_tree().reload_current_scene.call_deferred()


func _on_exit_button_pressed():
	load_main_menu()


func load_main_menu():
	get_tree().paused= true
	game_over_container.hide()
	get_tree().change_scene_to_packed.call_deferred(main_menu)


func is_ingame()-> bool:
	return get_tree().current_scene is Game
