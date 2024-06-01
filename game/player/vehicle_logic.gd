class_name PlayerVehicleLogic
extends Node

signal exit_vehicle

var seat: VehicleSeat
var entry_offset: Vector2



func on_enter(_seat: VehicleSeat):
	seat= _seat
	get_player().add_collision_exception_with(seat.get_vehicle())
	await get_tree().physics_frame
	entry_offset= get_player().global_position - seat.global_position
	get_player().global_position= seat.global_position
	get_player().main_hand.hide()


func exit():
	get_player().remove_collision_exception_with(seat.get_vehicle())
	get_player().global_position= seat.global_position + entry_offset
	get_player().main_hand.show()
	get_player().in_vehicle= null
	get_player().state_machine.paused= false
	exit_vehicle.emit()


func on_physics_process(delta: float):
	if Input.is_action_just_pressed("jump"):
		exit()
		return

	seat.get_vehicle().on_occupied_physics_process(delta)

	get_player().global_position= seat.global_position
	get_player().global_rotation= seat.global_rotation


func get_player()-> BasePlayer:
	return get_parent()
