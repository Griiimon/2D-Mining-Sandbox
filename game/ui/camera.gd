class_name Camera
extends Camera2D

@export var follow_node: Node2D
@export var free_cam: bool= false
@export var speed: float= 200
	

func _process(delta):
	if free_cam:
		position+= Input.get_vector("left", "right", "up", "down") * speed * delta
	elif follow_node and is_instance_valid(follow_node):
		position= follow_node.global_position
