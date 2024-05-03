class_name BaseMob
extends CharacterBody2D

var type: MobDefinition
var world: World
var state_machine: FiniteStateMachine



func _ready():
	state_machine= get_node_or_null("State Machine")


func distance_to_tile(tile: Vector2i)-> float:
	return (world.get_tile(global_position) - tile).length() 
