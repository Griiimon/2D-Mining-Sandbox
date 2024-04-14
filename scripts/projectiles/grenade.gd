extends Projectile
class_name Grenade

@export var explosion_damage: float= 5
@export var explosion_radius: float= 4


func _on_timer_timeout():
	get_world().explosion(get_world().get_tile(global_position), explosion_damage, explosion_radius)
	queue_free()
