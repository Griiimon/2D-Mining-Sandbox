class_name Camera
extends Camera2D

@export var follow_node: Node2D


func _process(delta):
	if follow_node:
		position= follow_node.global_position
