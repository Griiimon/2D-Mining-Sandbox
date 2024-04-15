class_name ParticleSettings
extends Resource


@export var num_particles: int= 10
@export var size: float= 5
@export var color: Color= Color.WHITE
@export var explosiveness: float= 1
@export var min_lifetime: float= 1
@export var max_lifetime: float= 1
@export var fade: bool= false
@export var initial_min_velocity: float= 10
@export var initial_max_velocity: float= 10
@export var gravity: float= 10
@export var direction: Vector2= Vector2.UP
@export var spread_angle: float= 360
@export var terrain_collision: bool= true
@export var bounce: float= 1
@export var damping: float= 0


func set_color(_color: Color):
	color= _color
	return self

#func _init(_num_particles: int, _size: float= 10, _color: Color= Color.WHITE, _explosiveness: float= 1, _min_life: float= 1, _max_life: float= 1, _fade: bool= false, _min_velocity: float= 10, _max_velocity: float= 10,\
		 #_gravity: float= 10, _direction: Vector2= Vector2.UP, _spread: float= 360, _collision: bool= true, _bounce: float= 0.1, _damping: float= 0):
	#num_particles= _num_particles
	#size= _size
	#color= _color
	#explosiveness= _explosiveness
	#min_lifetime= _min_life
	#max_lifetime= _max_life
	#fade= _fade
	#initial_min_velocity= _min_velocity
	#initial_max_velocity= _max_velocity
	#gravity= _gravity
	#direction= _direction
	#spread_angle= _spread
	#terrain_collision= _collision
	#bounce= _bounce
	#damping= _damping
