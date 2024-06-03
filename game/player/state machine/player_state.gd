extends StateMachineState
class_name PlayerState

signal use_item
signal charge_item


@export var player: BasePlayer
@export var can_move: bool= true


var selected_block_pos: Vector2i
var charge_primary: bool= true



func _ready():
	if not player:
		player= get_parent().get_parent()
	assert(player, get_tree_string() + " has no player assigned")


func select_block():
	var new_block_pos: = get_world().get_tile(get_tile_collision())
	if new_block_pos != selected_block_pos:
		on_selected_block_changed()
	selected_block_pos= new_block_pos
	update_block_marker()
	

func select_block_at(block_pos: Vector2i):
	if block_pos != selected_block_pos:
		on_selected_block_changed()
	selected_block_pos= block_pos
	update_block_marker()


func select_nearest_minable_tile(mining_range: int)-> bool:
	var from: Vector2i= player.get_tile_pos()
	var mine_positions: Array[Vector2i]= []

	for x in range(-mining_range, mining_range + 1):
		for y in range(-mining_range, mining_range + 1):
			var vec:= Vector2i(x, y)
			if vec.length() > mining_range or player.get_look_direction().dot(Vector2(vec).normalized()) < 0:
				continue
			var tile:= from + vec
			if get_world().is_block_solid_at(tile):
				mine_positions.append(tile)
	
	if mine_positions.is_empty():
		return false

	var best_match_pos: Vector2i
	var best_rating: float= -INF
	
	for to in mine_positions:
		var rating: float= pow(player.get_look_direction().dot(Vector2(to - from).normalized()), 3)
		rating*= 1.0 / (to - from).length()
		if rating > best_rating:
			best_match_pos= to
			best_rating= rating

	select_block_at(best_match_pos)

	return true


func mouse_actions():
	var is_charging:= false
	var primary: bool
	
	if player.has_hand_object():
		var action_name: String
		var hand_item_type: HandItem= player.get_hand_object().type
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			primary= true
			action_name= hand_item_type.primary_action_animation
			if hand_item_type.charge_primary_action:
				is_charging= true

		elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			primary= false
			action_name= hand_item_type.secondary_action_animation
			if hand_item_type.charge_secondary_action:
				is_charging= true

		if action_name:
			NodeDebugger.write(player, "hand action " + action_name, 2)
			player.on_hand_action(action_name)

			if is_charging:
				charge_primary= primary
				charge_item.emit()
			else:
				use_item.emit()
				player.hand_action_executed(action_name, primary)


func update_block_marker():
	player.block_marker.position= get_world().map_to_local(selected_block_pos)
	player.block_marker.show()


func get_empty_tile()-> Vector2i:
	return get_world().get_tile(get_tile_collision(false))

func on_selected_block_changed():
	pass


func is_raycast_hitting_terrain()-> bool: 
	if player.ray_cast.get_collider() is TileMap:
		return true
	return false


func get_tile_collision(inside: bool= true)-> Vector2:
	var point: Vector2= player.ray_cast.get_collision_point()
	
	# apply fix for collision rounding issue on tile border
	# by moving the collision point into or out of the tile
	
	point+= ( -1 if inside else 1 ) * player.ray_cast.get_collision_normal() * 0.1
	DebugHud.send("fixed tile collision", str(point))
	return point


func on_hand_action_finished():
	get_state_machine().change_state(get_state_machine().previous_state)
	

func can_mine()-> bool:
	return not player.has_hand_object() or player.get_hand_object().can_mine()


func get_world()-> World:
	return player.get_world()
