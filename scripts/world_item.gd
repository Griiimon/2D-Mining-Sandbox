class_name WorldItem
extends Area2D

@export var item_gravity: float= 100
@export var bounce: float= 20

@onready var sprite: Sprite2D = $Sprite2D
@onready var shape_cast: ShapeCast2D = $ShapeCast2D

var item: Item:
	set(i):
		if i:
			item= i
			sprite.texture= i.texture

var velocity: Vector2

func _physics_process(delta):
	if not shape_cast.is_colliding():
		velocity.y+= item_gravity * delta
	else:
		velocity.y= -bounce
	
	position+= velocity * delta
	
