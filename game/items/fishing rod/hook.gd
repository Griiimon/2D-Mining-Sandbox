class_name FishingRodHookBody
extends CharacterBody2D

@export var speed: float= 50.0
@export var gravity: float= 100.0

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var tile_detector: TileDetector = $"Tile Detector"



func _ready():
	set_physics_process(false)


func shoot(force: float, dir: Vector2):
	velocity= force * dir * speed
	collision_shape.set_deferred("disabled", false)
	tile_detector.active= true
	top_level= true
	set_physics_process(true)


func _physics_process(delta):
	if tile_detector.is_in_fluid():
		collision_shape.set_deferred("disabled", true)
		tile_detector.active= false
		set_physics_process(false)
		return

	velocity.y+= gravity * delta
	
	move_and_slide()
