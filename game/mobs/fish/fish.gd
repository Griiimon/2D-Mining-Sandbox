extends BaseMob

@export var min_speed: float= 2.0
@export var max_speed: float= 2.0
@export var gravity: float= 100.0


@onready var tile_detector: TileDetector = $"Tile Detector"
@onready var visual: Node2D = $Visual



func _ready():
	rand_velocity()


func _physics_process(delta):
	if tile_detector.is_in_fluid():
		if move_and_collide(velocity * delta, true) or velocity.y > max_speed:
			rand_velocity()
			return
	else:
		velocity.y+= gravity * delta
		velocity.x*= 1 - delta
	
	if not is_zero_approx(velocity.x):
		visual.scale.x= sign(velocity.x)
	move_and_slide()


func rand_velocity():
	velocity= Vector2.from_angle(randf() * 2 * PI)
	velocity*= randf_range(min_speed, max_speed)
