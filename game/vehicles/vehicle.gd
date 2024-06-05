class_name Vehicle
extends CharacterBody2D


@export var speed = 300.0
@export var gravity= 10.0



func _physics_process(delta: float):
	movement(delta)


func on_occupied_physics_process(_delta: float):
	pass


func movement(delta: float):
	if not is_on_floor():
		velocity.y += gravity * delta

	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()


func on_enter():
	pass


func on_exit():
	pass
