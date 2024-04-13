extends StateMachineState


signal wake_up



func on_enter():
	pass


func on_process(_delta):
	pass


func on_physics_process(_delta):
	pass


func on_exit():
	pass


func _on_movement_detection_body_entered(body):
	if is_current_state():
		wake_up.emit()
