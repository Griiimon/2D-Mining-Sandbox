extends Mob
class_name Bat

@onready var state_machine: FiniteStateMachine = $"State Machine"
@onready var sleep_state = $"State Machine/Sleep"
@onready var fly_state = $"State Machine/Fly"
@onready var flee_state = $"State Machine/Flee"




func _on_wake_up():
	state_machine.change_state(fly_state)
