extends Node



func run_game(scene: PackedScene):
	get_tree().change_scene_to_packed(scene)
	await get_tree().process_frame
	
	assert(get_tree().current_scene is Game)
	
	(get_tree().current_scene as Game).game_is_over.connect(game_over)


func game_over(win: bool):
	get_tree().paused= true


func _on_try_again_button_pressed():
	get_tree().reload_current_scene()


func _on_exit_button_pressed():
	pass # Replace with function body.
