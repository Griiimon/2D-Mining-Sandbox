extends CanvasLayer



func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("toggle_admin"):
			visible= not visible
			if Global.game and Global.game.player:
				Global.game.player.freeze= visible
