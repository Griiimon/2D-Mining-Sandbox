class_name WorldItem
extends Area2D

@export var item_gravity: float= 100
@export var bounce: float= 20

@onready var sprite: Sprite2D = $Sprite2D
@onready var shape_cast: ShapeCast2D = $ShapeCast2D

@onready var pickup_cooldown = $"Pickup Cooldown"

var item: Item:
	set(_item):
		if not _item:
			return
		
		item= _item
		sprite.texture= item.texture
		
		if item is HandItem:
			pickup_cooldown.start()


var velocity: Vector2


func _physics_process(delta):
	if not shape_cast.is_colliding():
		velocity.y+= item_gravity * delta
	else:
		var normal:= Vector2.ZERO
		
		for i in shape_cast.get_collision_count():
			normal+= shape_cast.get_collision_normal(i)
		
		normal= normal.normalized()
		
		if normal.dot(Vector2.DOWN) < 0.1:
			if velocity.y >= 0:
				velocity= velocity.normalized().bounce(normal) * bounce
		else:
			velocity.y= bounce

		velocity.x*= 0.5

	
	velocity.x*= 1 - delta
	position+= velocity * delta


func _on_body_entered(body):
	assert(body is Player)
	
	if not pickup_cooldown.is_stopped():
		return

	var player: Player= body
	if player.can_pickup(item):
		player.pickup(item)
		queue_free()


func _on_pickup_cooldown_timeout():
	for body in get_overlapping_bodies():
		_on_body_entered(body)
		if not is_instance_valid(self) or is_queued_for_deletion():
			break
