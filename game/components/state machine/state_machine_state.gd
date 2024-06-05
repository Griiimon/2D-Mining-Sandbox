class_name StateMachineState
extends Node


signal state_entered
signal state_exited

@export var auto_play_animation: String
@export var auto_stop_animation: bool= true


func on_enter():
	pass


func on_process(_delta: float):
	pass


func on_physics_process(_delta: float):
	pass


func on_unhandled_input(_event: InputEvent):
	pass


func on_exit():
	pass


func cancel():
	get_state_machine().change_state(null)


func is_current_state() -> bool:
	return get_state_machine().current_state == self
	

func get_state_machine()-> FiniteStateMachine:
	return get_parent()
