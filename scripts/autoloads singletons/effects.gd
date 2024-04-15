extends Node

const particle_system_scene= preload("res://scenes/effects/particle_system.tscn")
const fireworks_scene= preload("res://scenes/effects/fireworks.tscn")

func spawn_particle_system(pos: Vector2, settings: ParticleSettings):
	var system: MyParticleSystem= particle_system_scene.instantiate()
	system.position= pos
	system.init(settings)
	get_tree().current_scene.add_child(system)


func spawn_fireworks(pos: Vector2):
	var fireworks= fireworks_scene.instantiate()
	fireworks.position= pos
	get_tree().current_scene.add_child(fireworks)
