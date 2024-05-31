extends StateMachineState

@export var scene: PackedScene



func on_unhandled_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == MOUSE_BUTTON_LEFT:
				if Global.game and Global.game.world:
					var world: World= Global.game.world
					var obj= scene.instantiate()
					obj.position= world.get_global_mouse_position()
					world.add_child(obj)

			elif event.button_index == MOUSE_BUTTON_RIGHT:
				cancel()
