class_name WorldItem
extends Area2D

@export var item_gravity: float= 100
@export var bounce: float= 20
@export var x_damping: float= 1
@export var y_damping: float= 0.1
@export var pull_force: float= 10

@onready var sprite: Sprite2D = $Sprite2D
@onready var shape_cast: ShapeCast2D = $ShapeCast2D

@onready var pickup_cooldown = $"Pickup Cooldown"
@onready var pickup_delay = $"Pickup Delay"

@onready var magnet_range = $"Magnet Range"


var item: Item: set= set_item
var velocity: Vector2

var freeze: bool= false: set= set_freeze

var bounce_tween: Tween

var registered_to_chunk: WorldChunk


func _ready():
	pickup_delay.wait_time= randf_range(0, 0.3)

	# wait for shapecast to get collider information. necessary?
	set_physics_process(false)
	
	if not Global.game.settings.top_down_mode:
		await get_tree().physics_frame
		set_physics_process(true)


func _physics_process(delta):
	var being_pulled:= false
	
	for body in magnet_range.get_overlapping_bodies():
		assert(body is BasePlayer)
		
		if not pickup_cooldown.is_stopped():
			continue
		if is_instance_valid(pickup_delay):
			if pickup_delay.is_stopped():
				pickup_delay.start()
			continue
		

		var player: BasePlayer= body
		if player.can_pickup(item):
			velocity+= (player.global_position - global_position).normalized() * pull_force
			being_pulled= true

	if not shape_cast.is_colliding():
		freeze= false
		if not being_pulled:
			velocity.y+= item_gravity * delta
	else:
		if not freeze:
			var normal:= Vector2.ZERO
			
			for i in shape_cast.get_collision_count():
				normal+= shape_cast.get_collision_normal(i)
			
			normal= normal.normalized()
			
			if normal and normal.dot(Vector2.DOWN) < 0.1:
				if velocity.y >= 0:
					if abs(velocity.x) < 1:
						freeze= true
						return
					velocity= velocity.normalized().bounce(normal) * bounce
			else:
				velocity.y= bounce

			velocity.x*= 0.5

	velocity.x*= 1 - delta * x_damping
	velocity.y*= 1 - delta * y_damping
	position+= velocity * delta


func register(world: World):
	registered_to_chunk= world.register_item(self)


func _on_body_entered(body):
	assert(body is BasePlayer)
	
	if not pickup_cooldown.is_stopped():
		return

	var player: BasePlayer= body
	if player.can_pickup(item):
		player.pickup(item)
		queue_free()


func _on_pickup_cooldown_timeout():
	for body in get_overlapping_bodies():
		_on_body_entered(body)
		if not is_instance_valid(self) or is_queued_for_deletion():
			break


func set_item(_item: Item):
	if not _item:
		return
	
	item= _item
	sprite.texture= item.texture
	
	if item is HandItem:
		pickup_cooldown.start()


func _on_pickup_delay_timeout():
	pickup_delay.queue_free()


func set_freeze(b: bool):
	if freeze == b: return
	
	freeze= b
	if freeze:
		var world: World= registered_to_chunk.world
		world.unregister_item(self, registered_to_chunk)
		register(world)
		
		velocity= Vector2.ZERO
		bounce_tween= create_tween()
		bounce_tween.tween_property(sprite, "position:y", -5, 0.5)
		bounce_tween.tween_property(sprite, "position:y", 0, 0.5)
		bounce_tween.set_loops()
	else:
		if bounce_tween and bounce_tween.is_running():
			bounce_tween.kill()
			sprite.position.y= 0
