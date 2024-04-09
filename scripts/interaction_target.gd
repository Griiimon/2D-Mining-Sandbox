class_name InteractionTarget
extends Area2D

const INTERACT_METHOD= "interact"

@export var auto_retrieve_collision_shape: bool= true

@onready var collision_shape = $CollisionShape2D

var parent: Node2D

func _ready():
	parent= get_parent()
	
	assert(parent.has_method(INTERACT_METHOD))
	
	if auto_retrieve_collision_shape:
		var coll_shapes: Array[CollisionShape2D]
		coll_shapes.assign(parent.find_children("", "CollisionShape2D"))
		assert(coll_shapes.size() > 0)
		collision_shape.position= coll_shapes[0].position
		assert(coll_shapes[0].shape)
		collision_shape.shape= coll_shapes[0].shape


func interact(player: Player):
	parent.interact(player)
