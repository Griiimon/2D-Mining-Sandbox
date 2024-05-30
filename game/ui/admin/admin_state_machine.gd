class_name AdminStateMachine
extends FiniteStateMachine


@onready var water_row: StateMachineState = $"Water Row"


func _on_water_row_button_pressed():
	change_state(water_row)
