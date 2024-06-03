class_name FishingRodHookBody
extends CharacterBody2D

@export var speed: float= 50.0
@export var gravity: float= 100.0

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var tile_detector: TileDetector = $"Tile Detector"
@onready var fish_interest_area = $"Fish Interest Area"
@onready var fish_hook_area = $"Fish Hook Area"



func _ready():
	set_physics_process(false)


func shoot(from: Vector2, force: float, dir: Vector2):
	velocity= force * dir * speed
	collision_shape.set_deferred("disabled", false)
	fish_hook_area.set_deferred("monitoring", true)
	fish_interest_area.set_deferred("monitoring", true)
	tile_detector.active= true
	top_level= true
	position= from
	set_physics_process(true)


func _physics_process(delta):
	if tile_detector.is_in_fluid():
		collision_shape.set_deferred("disabled", true)
		fish_hook_area.set_deferred("monitoring", false)
		fish_interest_area.set_deferred("monitoring", false)
		tile_detector.active= false
		
		set_physics_process(false)
		return

	velocity.y+= gravity * delta
	
	move_and_slide()


func _on_fish_interest_area_body_entered(body):
	assert(body is BaseMob)
	if body is Fish:
		body.hook_interest(self)


func _on_fish_hook_area_body_entered(body):
	assert(body is BaseMob)
	if body is Fish:
		body.hook(self)
