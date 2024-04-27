extends PlayerState

signal stop_mining

var mining_progress: float



func on_enter():
	mining_progress= 0
	player.block_breaker.show()
	player.on_start_mining()


func on_exit():
	player.block_breaker.hide()
	player.on_stop_mining()


func on_physics_process(delta: float):
	if player.ray_cast.is_colliding() and is_raycast_hitting_terrain():
		select_block()
	else:
		stop_mining.emit()
	
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		stop_mining.emit()
		return

	mining_progress+= player.mining_speed * delta
	var block: Block= get_world().get_block(selected_block_pos)
	if not block:
		stop_mining.emit()
		return

	var total_mining_effort= block.hardness
	if player.get_hand_object_type() != block.mining_tool:
		total_mining_effort*= 1 + block.other_tool_penalty
		
	if mining_progress >= total_mining_effort or Global.game.cheats.instant_mine:
		get_world().break_block(selected_block_pos, player.get_hand_object_type() == block.mining_tool)
		NodeDebugger.msg(player, str("mined block ", selected_block_pos), 1)
		stop_mining.emit()
		return
	else:
		player.block_breaker.position= get_world().map_to_local(selected_block_pos)
		var frames: int= player.block_breaker.sprite_frames.get_frame_count("default")
		player.block_breaker.frame= int(frames * mining_progress / total_mining_effort)


func _on_player_ui_hotbar_slot_changed():
	if is_current_state():
		stop_mining.emit()


func on_selected_block_changed():
	stop_mining.emit()
