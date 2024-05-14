extends Node



func run_game(scene: PackedScene):
	run_deferred.call_deferred(scene)


func run_deferred(scene: PackedScene):
	assert(get_tree().change_scene_to_packed(scene) == OK)


func game_over(win: bool):
	get_tree().paused= true


func _on_try_again_button_pressed():
	get_tree().reload_current_scene()


func _on_exit_button_pressed():
	pass # Replace with function body.
