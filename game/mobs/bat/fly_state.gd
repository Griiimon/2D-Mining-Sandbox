extends StateMachineState

signal go_sleep

@export var speed: float= 50.0

@onready var fly_timer: Timer = $Timer
@onready var ray_cast = %"RayCast Ceiling"

var direction: Vector2



func on_enter():
	fly_timer.start()


func on_process(_delta):
	pass


func on_physics_process(delta):
	if can_enter_sleep():
		if ray_cast.is_colliding():
			go_sleep.emit()
			return

	if not direction:
		set_random_direction()
	
	var velocity= direction * speed
	if get_bat().move_and_collide(velocity * delta):
		set_random_direction()
		return


func on_exit():
	pass


func set_random_direction():
	direction= Vector2.from_angle(deg_to_rad(randf_range(0, 360)))
	if Utils.chance50():
		direction.y= 0
	direction= direction.normalized()
	if not direction:
		set_random_direction()


func can_enter_sleep()-> bool:
	return fly_timer.is_stopped()


func get_bat()-> Bat:
	return get_state_machine().get_parent()
