extends BaseMob
class_name Bat

@export var sleep_state: StateMachineState
@export var fly_state: StateMachineState



func _ready():
	super()
	assert(sleep_state)
	assert(fly_state)


func _on_wake_up():
	state_machine.change_state(fly_state)


func _on_fly_go_sleep():
	state_machine.change_state(sleep_state)
