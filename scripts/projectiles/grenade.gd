extends Projectile
class_name Grenade

@export var explosion_damage: float= 50
@export var block_damage_factor: float= 0.1
@export var explosion_radius: float= 4


func _on_timer_timeout():
	get_world().explosion(get_world().get_tile(global_position), explosion_damage, explosion_radius, block_damage_factor)
	queue_free()
