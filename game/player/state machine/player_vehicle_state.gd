class_name PlayerVehicleState
extends PlayerState

var seat: VehicleSeat


func on_enter():
	player.add_collision_exception_with(seat.get_vehicle())
	await get_tree().physics_frame
	player.global_position= seat.global_position
	player.freeze= true


func on_physics_process(_delta: float):
	player.global_position= seat.global_position
