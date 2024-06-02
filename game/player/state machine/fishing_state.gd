class_name PlayerFishingState
extends PlayerState

signal stop_fishing



func on_enter():
	player.block_marker.hide()


func on_physics_process(_delta: float):
	mouse_actions()
