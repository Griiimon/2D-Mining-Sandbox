class_name VirtualProjectileThrower
extends HandItemObject

@export var throw_force: float= 500

var hand_object: Node2D


func on_equip():
	var projectile: Projectile= type.scene.instantiate()
	
	add_child(projectile)
	hand_object= projectile.visual

	# reparent visual representation of projectile to virtual thrower
	hand_object.reparent(self, false)
	projectile.queue_free()


func release_charge(total_charge: float, primary: bool):
	if not primary: return
	var projectile: Projectile= type.scene.instantiate()
	projectile.position= get_hand().global_position
	hand_object.queue_free()
	Global.game.world.add_child(projectile)

	projectile.add_collision_exception_with(Global.game.player)
	projectile.shoot(get_player().get_look_direction() * total_charge * throw_force)

	remove_projectile_collision_exception(projectile)


func remove_projectile_collision_exception(projectile: Projectile):
	await get_tree().create_timer(0.5).timeout
	projectile.remove_collision_exception_with(Global.game.player)

