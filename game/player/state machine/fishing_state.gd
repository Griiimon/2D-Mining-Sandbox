class_name PlayerFishingState
extends PlayerState

signal stop_fishing



func on_enter():
	player.block_marker.hide()


func on_physics_process(_delta: float):
	if not player.has_hand_object() or not player.get_hand_object() is FishingRod:
		return
	if (player.get_hand_object() as FishingRod).reel_in: return
	mouse_actions()


func on_hand_action_finished():
	pass
