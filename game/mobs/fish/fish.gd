class_name Fish
extends BaseMob

@export var min_speed: float= 2.0
@export var max_speed: float= 2.0
@export var gravity: float= 100.0
@export var jump_velocity: float= -20.0
@export var colors: Array[Color]
@export var item: Item

@onready var tile_detector: TileDetector = $"Tile Detector"
@onready var visual: Node2D = $Visual
@onready var apply_color_to: Array[Node2D]= [$Visual/Polygon2D, $Visual/Polygon2D2]
@onready var dry_timer: Timer = $"Dry Timer"
@onready var mouth = $Mouth

var is_hooked: bool= false


func _ready():
	var color= colors.pick_random()
	for node in apply_color_to:
		node.color= color
	rand_velocity()


func _physics_process(delta):
	if is_hooked: return
	
	if tile_detector.is_in_fluid():
		dry_timer.stop()
		if get_slide_collision_count() > 0 or move_and_collide(velocity * delta, true) or velocity.y > max_speed:
			rand_velocity()
			#return
	else:
		if dry_timer.is_stopped():
			dry_timer.start()
		if my_is_on_floor() and Utils.chance100(30 * delta):
			velocity.y= jump_velocity
			velocity.x= sign(visual.scale.x) * jump_velocity
		else:
			velocity.y+= gravity * delta
		velocity.x*= 1 - delta
	
	if not is_zero_approx(velocity.x):
		visual.scale.x= sign(velocity.x)
	
	move_and_slide()


func rand_velocity():
	velocity= Vector2.from_angle(randf() * 2 * PI)
	velocity*= randf_range(min_speed, max_speed)


func die():
	set_physics_process(false)
	$HealthComponent.queue_free()
	$"Hurt Box".queue_free()
	
	%Eye.hide()
	%"Dead Eye".show()
	visual.scale.y= -1
	
	await get_tree().create_timer(10).timeout
	queue_free()


func my_is_on_floor()-> bool:
	if get_last_slide_collision():
		return get_last_slide_collision().get_normal().is_equal_approx(Vector2.UP)
	return false


func hook_interest(hook: FishingRodHookBody):
	velocity= mouth.global_position.direction_to(hook.global_position) * max_speed


func hook(hook: FishingRodHookBody):
	if is_hooked: return
	is_hooked= true
	visual.scale= Vector2(1, 1)
	look_at(global_position + Vector2.UP)
	reparent.call_deferred(hook)
	await get_tree().process_frame
	position= Vector2.ZERO
