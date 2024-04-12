extends Area2D

@export var damage: Damage
@export var exclude_hurtbox: HurtBox


func _ready():
	assert(damage != null, get_parent().name + " DamageArea is missing Damage Resource")
	set_collision_mask_value(Global.HURTBOX_LAYER, true)


func _on_area_entered(area):
	assert(area is HurtBox, "Damage Area encountered a non HurtBox " + area.name)
	var hurtbox= area as HurtBox
	if hurtbox == exclude_hurtbox: return
	hurtbox.receive_damage(damage)
