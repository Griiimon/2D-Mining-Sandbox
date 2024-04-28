extends PlayerState

signal build(scene, tile_pos)
signal cancel

var entity_scene: PackedScene
var ghost: BaseBlockEntity


func on_enter():
	entity_scene= load("res://game/block entities/furnace/furnace.tscn")
	ghost= entity_scene.instantiate()
	add_child(ghost)
	ghost.modulate= Color.WHITE.lerp(Color.TRANSPARENT, 0.5).lerp(Color.RED, 0.25)


func on_physics_process(delta: float):
	if player.ray_cast.is_colliding() and is_raycast_hitting_terrain():
		
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			build.emit()
