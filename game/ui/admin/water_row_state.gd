extends StateMachineState

@export var water_block: FluidBlock



func on_unhandled_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if Global.game and Global.game.world:
				var world: World= Global.game.world
				#var tile: Vector2i= world.local_to_map(event.position)
				var tile: Vector2i= world.local_to_map(world.get_global_mouse_position())

				var x:= 0
				while world.is_air_at(Vector2i(x, tile.y)):
					world.set_block(water_block, Vector2i(x, tile.y))
					x+= 1
				
				x= -1
				while world.is_air_at(Vector2i(x, tile.y)):
					world.set_block(water_block, Vector2i(x, tile.y))
					x-= 1
