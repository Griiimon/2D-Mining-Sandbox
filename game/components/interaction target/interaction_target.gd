class_name InteractionTarget
extends Area2D

const INTERACT_METHOD= "interact"
const CUSTOM_HINT_METHOD= "custom_interaction_hint"


@export var auto_retrieve_collision_shape: bool= true
@export var default_hint: String= "Press F to interact"

@onready var collision_shape = $CollisionShape2D
@onready var label_offset = $"Label Offset"

var parent: Node2D

func _ready():
	parent= get_parent()
	
	assert(parent.has_method(INTERACT_METHOD))
	
	await parent.ready
	
	if auto_retrieve_collision_shape:
		var coll_shapes: Array[CollisionShape2D]= []
		coll_shapes.assign(parent.find_children("", "CollisionShape2D"))
		assert(coll_shapes.size() > 0)
		collision_shape.position= coll_shapes[0].position
		assert(coll_shapes[0].shape)
		collision_shape.shape= coll_shapes[0].shape


func interact(player: BasePlayer):
	parent.interact(player)


func get_interaction_hint(player: BasePlayer)-> String:
	if parent.has_method(CUSTOM_HINT_METHOD):
		return parent.call(CUSTOM_HINT_METHOD, player, default_hint)

	return default_hint
