extends StateMachineState

@export var definition: MobDefinition



func on_unhandled_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == MOUSE_BUTTON_LEFT:
				if Global.game and Global.game.world:
					var world: World= Global.game.world
					world.spawn_mob(definition, world.local_to_map(world.get_global_mouse_position()))

			elif event.button_index == MOUSE_BUTTON_RIGHT:
				cancel()
