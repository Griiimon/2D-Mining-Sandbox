extends CharacterBody2D
class_name Projectile

@export var visual: Node2D

@export var gravity: float= 10
@export var damping: float= 0.1
@export var bounce: float= 0.8



func _physics_process(delta):
	velocity.y+= gravity * delta
	velocity*= 1 - delta * damping
		
	var collision: KinematicCollision2D= move_and_collide(velocity * delta)

	if collision:
		velocity= velocity.bounce(collision.get_normal()) * bounce


func shoot(_velocity: Vector2):
	velocity= _velocity


func get_world()-> World:
	return get_parent()
