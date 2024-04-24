extends StateMachineState
class_name BasePlayerState

@export var player: BasePlayer


var selected_block_pos: Vector2i

#var is_mining: bool= false: set= set_mining



func _ready():
	assert(player)


func on_physics_process(delta: float):
	interaction_logic()
	
	if player.ray_cast.is_colliding() and is_raycast_hitting_terrain():
		select_block()
		
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			if can_mine():
				is_mining= mining_logic(delta)
		else:
			is_mining= false
	else:
		player.block_marker.hide()
		is_mining= false
		
		mouse_actions()




func interaction_logic():
	var areas: Array[Area2D]= player.interaction_area.get_overlapping_areas()

	if areas.is_empty(): 
		player.ui.set_interaction_hint()
		return
	
	var interaction_target: InteractionTarget= areas[0]

	player.ui.set_interaction_hint(interaction_target.get_interaction_hint(player), interaction_target.label_offset.global_position)

	if Input.is_action_just_pressed("interact"):
		interaction_target.interact(player)


func mouse_actions():
	if is_charging:
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and not Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			release_charge()

	elif not is_executing_hand_action:

		if has_hand_object():
			var action_name: String
			var hand_item_type: HandItem= get_hand_object().type
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				action_name= hand_item_type.primary_action_animation
				if hand_item_type.charge_primary_action:
					is_charging= true
					charge_primary= true

			elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
				action_name= hand_item_type.secondary_action_animation
				if hand_item_type.charge_secondary_action:
					is_charging= true
					charge_primary= false

			if action_name:
				NodeDebugger.msg(self, "hand action " + action_name, 2)
				on_hand_action(action_name)
				is_executing_hand_action= true
				if not is_charging:
					hand_action_executed(action_name)


func select_block():
	var new_block_pos: = get_world().get_tile(get_tile_collision())
	if new_block_pos != selected_block_pos:
		mining_progress= 0
	selected_block_pos= new_block_pos
	
	player.block_marker.position= get_world().map_to_local(selected_block_pos)
	player.block_marker.show()


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


func set_mining(b: bool):
	if b == is_mining: return
	is_mining= b
	if not is_mining:
		mining_progress= 0
		player.block_breaker.hide()
		player.on_stop_mining()
	else:
		player.block_breaker.show()
		player.on_start_mining()



func get_world()-> World:
	return player.get_world()
