class_name Player
extends CharacterBody2D


@export var speed = 300.0
@export var jump_velocity = -400.0
@export var mining_speed= 1.0

@export_category("Scenes")
@export var block_marker_scene: PackedScene
@export var block_breaker_scene: PackedScene


@onready var body: Node2D = $Body
@onready var look_pivot: Node2D = $"Body/Look Pivot"
@onready var ray_cast: RayCast2D = %RayCast2D

@onready var animation_player_hand = $"AnimationPlayer Hand"
@onready var animation_player_feet = $"AnimationPlayer Feet"



var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# rectangle to mark the block we are currently looking at
var block_marker: Sprite2D
# overlay to indicate the breaking progress of the currently mined block
var block_breaker: AnimatedSprite2D

var is_mining: bool= false
var mining_progress: float


func _ready():
	block_marker= block_marker_scene.instantiate()
	add_child(block_marker)
	block_marker.top_level= true
	block_marker.hide()
	
	block_breaker= block_breaker_scene.instantiate()
	add_child(block_breaker)
	block_breaker.top_level= true
	block_breaker.hide()


func _process(_delta):
	var mouse_pos: Vector2= get_global_mouse_position()
	
	if mouse_pos.x >= position.x:
		body.scale.x= 1
	else:
		body.scale.x= -1

	look_pivot.look_at(mouse_pos)


func _physics_process(delta):
	movement(delta)
	
	is_mining= false
	
	if ray_cast.is_colliding():
		var block_pos: Vector2i= get_world().get_tile(get_tile_collision())
		
		block_marker.position= get_world().map_to_local(block_pos)
		block_marker.show()
		
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			is_mining= true
			mining_progress+= mining_speed * delta
			var block_hardness: float= get_world().get_block_hardness(block_pos)
			
			if mining_progress >= block_hardness:
				is_mining= false
				get_world().break_block(block_pos)
			
			else:
				block_breaker.position= get_world().map_to_local(block_pos)
				var frames: int= block_breaker.sprite_frames.get_frame_count("default")
				block_breaker.frame= int(frames * mining_progress / block_hardness)
				block_breaker.show()
				animation_player_hand.play("Mine")
			
	else:
		block_marker.hide()
	
	if not is_mining:
		mining_progress= 0
		block_breaker.hide()
		animation_player_hand.play("RESET")
		

func movement(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	if abs(velocity.x) > 0:
		animation_player_feet.play("Walk")
	else:
		animation_player_feet.play("RESET")

	move_and_slide()


func get_tile_collision()-> Vector2i:
	var point: Vector2= ray_cast.get_collision_point()
	
	# apply fix for collision rounding issue on tile border
	# by moving the collision point into the tile
	
	point+= -ray_cast.get_collision_normal() * 0.1

	return point

func get_world()-> World:
	return get_parent().world
