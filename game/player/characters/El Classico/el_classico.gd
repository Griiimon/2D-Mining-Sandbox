extends BasePlayer


@onready var animation_player_hand = $"AnimationPlayer Hand"
@onready var animation_player_feet = $"AnimationPlayer Feet"



func on_movement_jump():
	animation_player_feet.play("jump")


func on_movement_walk():
	animation_player_feet.play("walk")


func on_movement_stop():
	animation_player_feet.play("RESET")


func on_swim():
	animation_player_feet.play("RESET")


func on_hand_action(action_name: String):
	animation_player_hand.play(action_name)


func on_start_mining():
	animation_player_hand.play("mine")


func on_stop_mining():
	animation_player_hand.play("RESET")
