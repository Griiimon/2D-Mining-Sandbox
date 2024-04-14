extends Projectile
class_name Grenade

@export var explosion_damage: float= 10
@export var explosion_range: float= 2


func _on_timer_timeout():
	get_world().explosion(get_world().local_to_map(global_position), explosion_damage, explosion_radius)
	queue_free()
