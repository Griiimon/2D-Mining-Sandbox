extends StateMachineState

signal wake_up

@onready var visual = %Visual


func on_enter():
	visual.scale.y= -1


func on_process(_delta):
	pass


func on_physics_process(_delta):
	pass


func on_exit():
	visual.scale.y= 1


func _on_movement_detection_body_entered(body):
	assert(body is BasePlayer)
	if is_current_state():
		wake_up.emit()
