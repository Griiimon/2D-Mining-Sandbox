class_name FiniteStateMachine
extends Node

signal state_changed(new_state: StateMachineState)

@export var current_state: StateMachineState = null: set = set_current_state
@export var previous_state: StateMachineState = null
@export var allow_no_state: bool= false
@export var animation_player: AnimationPlayer
@export var debug: bool= false
@export var paused: bool= false



func _ready():
	late_ready.call_deferred()


func late_ready():
	assert(current_state or allow_no_state, "No FSM initial state " + get_parent().name)


func _process(delta: float):
	if current_state and not paused:
		current_state.on_process(delta)


func _physics_process(delta: float):
	if current_state and not paused:
		current_state.on_physics_process(delta)


func _unhandled_input(event: InputEvent):
	if current_state and not paused:
		current_state.on_unhandled_input(event)


func change_state(next_state: StateMachineState):
	if next_state:
		previous_state= current_state
		current_state = next_state
	else:
		if not allow_no_state:
			push_error("Not a valid StateMachineState")
		else:
			if current_state:
				current_state.on_exit()
				current_state.state_exited.emit()
				current_state= null


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


func cancel_state():
	assert(allow_no_state)
	change_state(null)
