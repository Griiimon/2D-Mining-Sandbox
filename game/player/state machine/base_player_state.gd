extends StateMachineState
class_name BasePlayerState

@export var player: BasePlayer


var selected_block_pos: Vector2i

var charge_primary: bool= true



func _ready():
	assert(player)


func select_block():
	var new_block_pos: = get_world().get_tile(get_tile_collision())
	if new_block_pos != selected_block_pos:
		on_selected_block_changed()
	selected_block_pos= new_block_pos
	
	player.block_marker.position= get_world().map_to_local(selected_block_pos)
	player.block_marker.show()


func on_selected_block_changed():
	pass


func is_raycast_hitting_terrain()-> bool: 
	if player.ray_cast.get_collider() is TileMap:
		return true
	return false


func get_tile_collision()-> Vector2:
	var point: Vector2= player.ray_cast.get_collision_point()
	
	# apply fix for collision rounding issue on tile border
	# by moving the collision point into the tile
	
	point+= -player.ray_cast.get_collision_normal() * 0.1
	DebugHud.send("fixed tile collision", str(point))
	return point


func can_mine()-> bool:
	return not player.has_hand_object() or player.get_hand_object().can_mine()


func get_world()-> World:
	return player.get_world()
