class_name PlayerFishingState
extends PlayerState

signal stop_fishing



func on_enter():
	player.block_marker.hide()


func on_physics_process(_delta: float):
	assert(player.has_hand_object() and player.get_hand_object() is FishingRod)
	if (player.get_hand_object() as FishingRod).reel_in: return
	mouse_actions()


func on_hand_action_finished():
	pass
