class_name FiniteStateMachine
extends Node

signal state_changed(new_state: StateMachineState)

@export var current_state: StateMachineState = null: set = set_current_state
@export var animation_player: AnimationPlayer



func _process(delta: float) -> void:
	if current_state:
		current_state.on_process(delta)


func _physics_process(delta: float) -> void:
	if current_state:
		current_state.on_physics_process(delta)


func change_state(node_path: NodePath) -> void:
	var next_state: StateMachineState= get_node_or_null(node_path)
	if next_state:
		current_state = next_state
	else:
		push_error("Node ", next_state, " at path ", node_path, " is not a valid StateMachineState")


func set_current_state(next_state: StateMachineState) -> void:
	if not is_inside_tree():
		await ready
		
	if current_state:
		current_state.on_exit()
		current_state.state_exited.emit()
	current_state = next_state

	if current_state:
		state_changed.emit(current_state)
		if current_state.auto_play_animation and animation_player:
			animation_player.play(current_state.auto_play_animation)
		current_state.on_enter()
		current_state.state_entered.emit()
