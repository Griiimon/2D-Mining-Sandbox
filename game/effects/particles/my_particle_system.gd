class_name MyParticleSystem
extends Node2D


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


