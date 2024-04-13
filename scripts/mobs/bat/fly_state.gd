extends StateMachineState

@export var speed: float= 50.0

@onready var fly_timer: Timer = $Timer

var direction: Vector2



func on_enter():
	fly_timer.start()


func on_process(_delta):
	pass


func on_physics_process(delta):
	if not direction:
		set_random_direction()
	
	var velocity= direction * speed
	if get_bat().move_and_collide(velocity * delta):
		set_random_direction()


func on_exit():
	pass


func set_random_direction():
	direction= Vector2.from_angle(deg_to_rad(randf_range(0, 360)))
	if Utils.chance50():
		direction.y= 0
	direction= direction.normalized()
	if not direction:
		set_random_direction()


func get_bat()-> Bat:
	return get_state_machine().get_parent()
