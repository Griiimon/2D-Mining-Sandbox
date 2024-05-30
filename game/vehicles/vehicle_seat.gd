class_name VehicleSeat
extends Node2D




func _on_area_2d_body_entered(body):
	assert(body is BasePlayer)
	var player: BasePlayer= body
	player.enter_vehicle_seat(self)


func get_vehicle()-> Vehicle:
	return get_parent()
