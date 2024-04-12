extends Area2D
class_name HurtBox

@export var health_component: HealthComponent


func _ready():
	assert(health_component, "HealthComponent in HurtBox of " + get_parent().name + " not set")
	set_collision_layer_value(Global.HURTBOX_LAYER, true)


func receive_damage(damage: Damage):
	health_component.receive_damage(damage)
