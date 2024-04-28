extends PlayerState

signal build(scene, tile_pos)
signal cancel

enum Type { Entity, Block }

var type: Type
var entity_scene: PackedScene
var ghost: BaseBlockEntity
var block: Block

var empty_tile: Vector2i: set= set_empty_tile

func on_enter():
	type= Type.Entity
	entity_scene= load("res://game/block entities/furnace/furnace.tscn")
	ghost= entity_scene.instantiate()
	add_child(ghost)
	ghost.modulate= Color.WHITE.lerp(Color.TRANSPARENT, 0.5).lerp(Color.RED, 0.25)


func on_physics_process(delta: float):
	if player.ray_cast.is_colliding():
		empty_tile= get_empty_tile()

		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			build.emit(entity_scene, empty_tile)


func set_empty_tile(tile_pos: Vector2i):
	if tile_pos == empty_tile: return
	
	empty_tile= tile_pos
