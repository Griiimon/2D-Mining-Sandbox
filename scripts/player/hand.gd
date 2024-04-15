extends Node2D
class_name Hand

@export var player: Player

@onready var connector = $Connector



func _ready():
	assert(player)


func set_attack_state(b: bool):
	assert(has_hand_object())
	get_hand_object().set_attack_state(b)


func has_hand_object()-> bool:
	return connector.get_child_count() > 0


func get_hand_object()-> HandItemObject:
	return connector.get_child(0)
