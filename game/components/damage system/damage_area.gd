extends Area2D

@export var damage: Damage
@export var exclude_hurtbox: HurtBox
@export var interval: float= 0
@export var damage_solid_block_entity: bool= true
@export var enabled: bool= true: set= set_enabled

@onready var collision_shape = $CollisionShape2D



func _ready():
	assert(damage != null, get_parent().name + " DamageArea is missing Damage Resource")
	set_collision_mask_value(Global.HURTBOX_COLLISION_LAYER, true)
	
	if damage_solid_block_entity:
		set_collision_mask_value(Global.SOLID_ENTITY_COLLISION_LAYER, true)
	
	if interval:
		var timer:= Timer.new()
		timer.autostart= true
		timer.one_shot= false
		add_child(timer)
		timer.timeout.connect(on_interval_timeout)


func _on_area_entered(area):
	assert(area is HurtBox, "Damage Area encountered a non HurtBox " + area.name)
	var hurtbox= area as HurtBox
	if hurtbox == exclude_hurtbox: return
	hurtbox.receive_damage(damage)


func set_enabled(b: bool):
	if enabled != b:
		enabled= b
		if not collision_shape:
			await ready
		collision_shape.disabled= not enabled
	if enabled:
		for overlap in get_overlapping_areas():
			# makes sure to trigger area_entered even if its already overlapping when enabled
			_on_area_entered(overlap)


func on_interval_timeout():
	set_enabled(true)
	set_enabled.call_deferred(false)
