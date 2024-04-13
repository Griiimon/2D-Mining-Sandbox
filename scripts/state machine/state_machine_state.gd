class_name StateMachineState
extends Node


signal state_entered
signal state_exited

@export var auto_play_animation: String



func on_enter() -> void:
	pass


func on_process(_delta: float) -> void:
	pass


func on_physics_process(_delta: float) -> void:
	pass


func on_exit() -> void:
	pass


func change_state(state_name: String) -> void:
	get_state_machine().change_state(state_name)


func is_current_state() -> bool:
	return get_state_machine().current_state == self
	

func get_state_machine()-> FiniteStateMachine:
	return get_parent()
