extends PlayerState

signal start_mining
signal use_item
signal charge_item



func on_physics_process(_delta: float):
	if Input.is_action_just_pressed("toggle_build_menu"):
		player.ui.toggle_build_menu()

	if player.is_frozen(): return

	interaction_logic()
	
	var can_mine:= false
	var mining_state: PlayerMiningState= (get_state_machine() as PlayerStateMachine).mining_state
	
	match mining_state.selection_mode:
		PlayerMiningState.SelectionMode.RAYCAST:
			if player.ray_cast.is_colliding() and is_raycast_hitting_terrain():
				select_block()
				can_mine= true
		PlayerMiningState.SelectionMode.NEAREST:
			if select_nearest_minable_tile(mining_state.mining_range):
				can_mine= true


	if can_mine:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			if can_mine():
				start_mining.emit()

	else:
		player.block_marker.hide()
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
