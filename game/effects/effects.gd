extends Node

@export var particle_system_scene: PackedScene
@export var fireworks_scene: PackedScene


func spawn_particle_system(pos: Vector2, settings: ParticleSettings):
	var system: MyParticleSystem= particle_system_scene.instantiate()
	system.position= pos
	system.init(settings)
	get_tree().current_scene.add_child(system)


func spawn_fireworks(pos: Vector2):
	var fireworks= fireworks_scene.instantiate()
	fireworks.position= pos
	get_tree().current_scene.add_child(fireworks)
