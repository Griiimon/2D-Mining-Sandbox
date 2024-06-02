extends PlayerState

signal start_mining



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
