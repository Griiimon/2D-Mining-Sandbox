class_name Game
extends Node

@export var world: World



func _ready():
	pass


func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
