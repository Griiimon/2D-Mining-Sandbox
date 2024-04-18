class_name MyParticle
extends Node2D

@onready var ray_cast = $RayCast2D

var velocity: Vector2
var lifetime: float

var particle_system: MyParticleSystem


func init(_system: MyParticleSystem):
	particle_system= _system
	
	var settings: ParticleSettings= particle_system.settings

	lifetime= randf_range(settings.min_lifetime, settings.max_lifetime)
	velocity= settings.direction.rotated(deg_to_rad(randf_range(-settings.spread_angle, settings.spread_angle))) * randf_range(settings.initial_min_velocity, settings.initial_max_velocity)

	ray_cast.enabled= settings.terrain_collision
	ray_cast.target_position= velocity * 0.01

	queue_redraw()


func _physics_process(delta):
	var settings: ParticleSettings= particle_system.settings

	if ray_cast.is_colliding():
		velocity= velocity.normalized().bounce(ray_cast.get_collision_normal()) * velocity.length() * settings.bounce
	else:
		velocity.y+= settings.gravity * delta
		velocity*= 1 - delta * settings.damping
	
	ray_cast.target_position= velocity * delta
	
	position+= velocity * delta
	
	lifetime-= delta

	if settings.fade:
		modulate.a= min(lifetime, 1)
	
	if lifetime <= 0:
		particle_system.on_particle_destroyed()
		queue_free()

func _draw():
	if not particle_system: return

	var settings: ParticleSettings= particle_system.settings
	
	draw_rect(Rect2(-Vector2.ONE * settings.size / 2, Vector2.ONE * settings.size), settings.color)



