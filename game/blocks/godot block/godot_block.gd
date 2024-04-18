extends Block
class_name GodotBlock


func on_break(world: World, block_pos: Vector2i):
	Effects.spawn_fireworks(world.map_to_local(block_pos))


