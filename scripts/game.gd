class_name Game
extends Node

@export var world: World
@export var settings: GameSettings
@export var cheats: Cheats


func _init():
	Global.game= self
	

func _ready():
	assert(cheats)
	assert(settings)


func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
