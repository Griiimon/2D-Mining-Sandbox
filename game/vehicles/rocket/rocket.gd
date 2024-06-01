extends Vehicle

@export var acceleration: float= 200.0
@export var drag: float= 0.01
@export var turn_speed: float= 1.0

@onready var flame: Sprite2D = $Flame



func _physics_process(delta):
	velocity.y+= gravity * delta
	velocity*= (1 - delta * drag)

	move_and_slide()


func on_occupied_physics_process(delta: float):
	if Input.is_action_pressed("up"):
		velocity+= acceleration * delta * -transform.y
		flame.show()
	else:
		flame.hide()
	
	rotate(Input.get_axis("left", "right") * turn_speed * delta)


func on_exit():
	flame.hide()
