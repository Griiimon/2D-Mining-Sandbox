extends Area2D
class_name HurtBox

@export var health_component: HealthComponent

@onready var collision_shape = $CollisionShape2D



func _ready():
	assert(health_component, "HealthComponent in HurtBox of " + get_parent().name + " not set")
	set_collision_layer_value(Global.HURTBOX_COLLISION_LAYER, true)

	if not collision_shape.shape:
		await get_parent().ready
		var parent_coll_shapes: Array[CollisionShape2D]= []
		parent_coll_shapes.assign(get_parent().find_children("", "CollisionShape2D"))
		if parent_coll_shapes:
			collision_shape.shape= parent_coll_shapes[0].shape
	
	assert(collision_shape.shape, "Hurtbox doesnt have a collision shape")


func receive_damage(damage: Damage):
	health_component.receive_damage(damage)
