extends Area2D

@export var damage: Damage
@export var exclude_hurtbox: HurtBox

@export var enabled: bool= true:
	set(b):
		if enabled != b:
			enabled= b
			if not collision_shape:
				await ready
			collision_shape.disabled= not enabled
		if enabled:
			for overlap in get_overlapping_areas():
				# makes sure to trigger area_entered even if its already overlapping when enabled
				_on_area_entered(overlap)


@onready var collision_shape = $CollisionShape2D



func _ready():
	assert(damage != null, get_parent().name + " DamageArea is missing Damage Resource")
	set_collision_mask_value(Global.HURTBOX_COLLISION_LAYER, true)


func _on_area_entered(area):
	assert(area is HurtBox, "Damage Area encountered a non HurtBox " + area.name)
	var hurtbox= area as HurtBox
	if hurtbox == exclude_hurtbox: return
	hurtbox.receive_damage(damage)
