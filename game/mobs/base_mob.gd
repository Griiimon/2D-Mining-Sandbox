class_name BaseMob
extends CharacterBody2D

var state_machine: FiniteStateMachine



func _ready():
	state_machine= get_node_or_null("State Machine")
