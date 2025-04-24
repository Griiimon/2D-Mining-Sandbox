extends BasePlayer


@onready var animation_player_hand = $"AnimationPlayer Hand"
@onready var animation_player_feet = $"AnimationPlayer Feet"


func _process(_delta):
	if velocity.length() > 0:
		# When moving, update the body rotation to match the movement direction
		body.rotation = velocity.angle()


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


func subscribe_hand_action_finished(action_name: String, method: Callable):
	assert(animation_player_hand.has_animation(action_name))
	animation_player_hand.animation_finished.connect(method, CONNECT_ONE_SHOT)


func on_hand_action_finished():
	animation_player_hand.play("RESET")


func on_start_mining(action_name: String):
	animation_player_hand.play(action_name)


func on_stop_mining():
	animation_player_hand.play("RESET")


func _on_health_component_report_damage(_damage: Damage, _hitpoints: float):
	$"AudioStreamPlayer Hurt".play()


func _on_vehicle_state_entered():
	animation_player_feet.play("enter_vehicle")


func _on_vehicle_state_exited():
	animation_player_feet.play("exit_vehicle")


func on_death():
	animation_player_hand.play("RESET")
	animation_player_feet.play("RESET")


