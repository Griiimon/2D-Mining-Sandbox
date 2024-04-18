class_name FiniteStateMachine
extends Node

signal state_changed(new_state: StateMachineState)

@export var current_state: StateMachineState = null: set = set_current_state
@export var animation_player: AnimationPlayer
@export var debug: bool= false


func _process(delta: float):
	if current_state:
		current_state.on_process(delta)


func _physics_process(delta: float):
	if current_state:
		current_state.on_physics_process(delta)


func change_state(next_state: StateMachineState):
	if next_state:
		current_state = next_state
	else:
		push_error("Not a valid StateMachineState")


func set_current_state(next_state: StateMachineState):
	if not is_inside_tree():
		await ready
		
	if current_state:
		if debug:
			print(get_parent().name + " State Machine exiting state " + current_state.name)
		if current_state.auto_stop_animation and animation_player:
			animation_player.stop()
		current_state.on_exit()
		current_state.state_exited.emit()
	current_state = next_state

	if current_state:
		if debug:
			print(get_parent().name + " State Machine changing state to " + current_state.name)
		state_changed.emit(current_state)
		if current_state.auto_play_animation and animation_player:
			animation_player.play(current_state.auto_play_animation)
		current_state.on_enter()
		current_state.state_entered.emit()
