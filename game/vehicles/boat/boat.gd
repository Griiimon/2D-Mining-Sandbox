class_name Boat
extends Vehicle

@export var lift: float= 10.0

@export var air_damp: float= 1.0
@export var water_damp: float= 3.0

@onready var tile_detector: TileDetector = $"Tile Detector"


func movement(delta: float):
	if not is_on_floor() and not tile_detector.is_in_fluid():
		velocity.y += gravity * delta
		velocity.y*= (1 - delta * air_damp) 
	elif tile_detector.is_in_fluid():
		velocity.y -= lift * delta
		velocity.y*= (1 - delta * water_damp) 
		
	move_and_slide()


func on_occupied_physics_process(delta: float):
	velocity.x= Input.get_axis("left", "right") * speed
