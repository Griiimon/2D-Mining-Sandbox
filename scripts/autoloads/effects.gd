extends Node

const particle_system_scene= preload("res://scenes/effects/particle_system.tscn")


func spawn_particle_system(pos: Vector2, settings: MyParticleSystem.ParticleSettings):
	var system: MyParticleSystem= particle_system_scene.instantiate()
	system.position= pos
	system.init(settings)
	get_tree().current_scene.add_child(system)
