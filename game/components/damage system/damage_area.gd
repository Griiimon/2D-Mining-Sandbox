extends Area2D
class_name DamageArea

@export var damage: Damage
@export var exclude_hurtbox: HurtBox
@export var interval: float= 0
@export var damage_solid_block_entity: bool= true
@export var enabled: bool= true: set= set_enabled
@export var can_damage_player: bool= true

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
	if not can_damage_player and hurtbox.get_parent() is BasePlayer:
		return
	hurtbox.receive_damage(damage)


func _on_body_entered(body):
	var health_component= body.get_node_or_null(Global.HEALTH_COMPONENT_NODE)
	if health_component: 
		health_component.receive_damage(damage)

func set_enabled(b: bool):
	if enabled != b:
		enabled= b
		if not collision_shape:
			await ready
		collision_shape.disabled= not enabled

	if enabled:
		# makes sure to trigger entered even if its already overlapping when enabled
		for overlap in get_overlapping_areas():
			_on_area_entered(overlap)
		
		if damage_solid_block_entity:
			for overlap in get_overlapping_bodies():
				_on_body_entered(overlap)


func on_interval_timeout():
	set_enabled(true)
	set_enabled.call_deferred(false)

