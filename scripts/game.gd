class_name Game
extends Node

@export var world: World
@export var settings: GameSettings
@export var cheats: Cheats
@export var player_scene: PackedScene

@onready var camera = $Camera2D

var player: Player


func _init():
	Global.game= self
	

func _ready():
	assert(cheats)
	assert(settings)
	
	await world.initialization_finished
	
	if not player:
		player= player_scene.instantiate()
		player.position= settings.player_spawn
		add_child(player)
		camera.follow_node= player


func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	elif Input.is_action_just_pressed("toggle_free_cam"):
		camera.free_cam= not camera.free_cam
		player.freeze= camera.free_cam
