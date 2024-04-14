class_name VirtualProjectileThrower
extends HandItemObject

var hand_object: Node2D


func on_equip():
	var projectile: Projectile= type.scene.instantiate()
	var hand: Hand= get_parent()
	hand.add_child(projectile)
	hand_object= projectile.visual
	# reparent visual representation of projectile to virtual thrower
	hand_object.reparent(hand.player.get_hand_item())
	projectile.queue_free()


func release_charge(total_charge: float, primary: bool):
	var hand: Hand= get_parent()
	var projectile: Projectile= type.scene.instantiate()
	projectile.position= hand.global_position
	hand_object.queue_free()
	Global.game.world.add_child(projectile)
	projectile.shoot(hand.player.get_look_direction() * total_charge * 500)
