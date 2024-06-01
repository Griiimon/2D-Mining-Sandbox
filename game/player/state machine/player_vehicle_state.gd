class_name PlayerVehicleState
extends PlayerState

signal exit_vehicle

var seat: VehicleSeat

var entry_offset: Vector2


func on_enter():
	player.add_collision_exception_with(seat.get_vehicle())
	await get_tree().physics_frame
	entry_offset= player.global_position - seat.global_position
	player.global_position= seat.global_position


func on_exit():
	player.remove_collision_exception_with(seat.get_vehicle())
	player.global_position= seat.global_position + entry_offset


func on_physics_process(delta: float):
	if Input.is_action_just_pressed("jump"):
		exit_vehicle.emit()
		return

	seat.get_vehicle().on_occupied_physics_process(delta)

	player.global_position= seat.global_position
	player.global_rotation= seat.global_rotation
