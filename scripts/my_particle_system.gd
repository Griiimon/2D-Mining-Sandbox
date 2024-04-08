class_name MyParticleSystem
extends Node2D


class ParticleSettings:
	var num_particles: int
	var size: float
	var color: Color
	var explosiveness: float
	var min_lifetime: float
	var max_lifetime: float
	var fade: bool
	var initial_min_velocity: float
	var initial_max_velocity: float
	var gravity: float
	var direction: Vector2
	var spread_angle: float
	var terrain_collision: bool
	var bounce: float
	var damping: float
	
	
	func _init(_num_particles: int, _size: float= 10, _color: Color= Color.WHITE, _explosiveness: float= 1, _min_life: float= 1, _max_life: float= 1, _fade: bool= false, _min_velocity: float= 10, _max_velocity: float= 10,\
			 _gravity: float= 10, _direction: Vector2= Vector2.UP, _spread: float= 0, _collision: bool= true, _bounce: float= 0.1, _damping: float= 0):
		num_particles= _num_particles
		size= _size
		color= _color
		explosiveness= _explosiveness
		min_lifetime= _min_life
		max_lifetime= _max_life
		fade= _fade
		initial_min_velocity= _min_velocity
		initial_max_velocity= _max_velocity
		gravity= _gravity
		direction= _direction
		spread_angle= _spread
		terrain_collision= _collision
		bounce= _bounce
		damping= _damping


@export var particle_scene: PackedScene

var settings: ParticleSettings
var emitting: bool= false
var autostart: bool= true
var destroy_when_finished: bool= true

var spawned_particles: int
var time: float

var destroyed_particles: int

func init(_settings: ParticleSettings):
	settings= _settings
	if autostart:
		start()


func start():
	emitting= true


func _process(delta):
	if not emitting: return
	
	var to_emit= lerp(0.0, float(settings.num_particles), time / max(0.001, settings.min_lifetime * ( 1 - settings.explosiveness )))
	
	while spawned_particles < to_emit and spawned_particles < settings.num_particles:
		spawn_particle()
	
	if spawned_particles >= settings.num_particles:
		emitting= false
		return
	
	time+= delta


func spawn_particle():
	var particle: MyParticle= particle_scene.instantiate()
	add_child(particle)
	particle.init(self)
	spawned_particles+= 1


func finished():
	emitting= false
	if destroy_when_finished:
		queue_free()


func on_particle_destroyed():
	destroyed_particles+= 1
	if destroyed_particles >= settings.num_particles:
		finished()


