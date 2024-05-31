class_name AdminStateMachine
extends FiniteStateMachine


@onready var water_row: StateMachineState = $"Water Row"
@onready var spawn_scene: StateMachineState = $"Spawn Scene"
@onready var spawn_mob: StateMachineState = $"Spawn Mob"


func _on_water_row_button_pressed():
	change_state(water_row)


func _on_spawn_scene_button_pressed():
	change_state(spawn_scene)


func _on_spawn_mob_button_pressed():
	change_state(spawn_mob)
