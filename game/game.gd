class_name Game
extends Node

signal game_is_over

@export var world: World
@export var settings: GameSettings
@export var cheats: Cheats
@export var can_toggle_cheats: bool= true
@export var player_scene: PackedScene

@onready var camera = $Camera2D

var player: BasePlayer



func _init():
	Global.game= self
	

func _ready():
	get_tree().paused= false

	game_is_over.connect(GameManager.game_over)

	if not settings:
		settings= GameSettings.new()

	if not cheats:
		cheats= Cheats.new()
	
	if not world:
		world= get_node_or_null("World")
		assert(world)
	
	if GameManager.character:
		player_scene= GameManager.character
	
	if not player_scene:
		player_scene= DataManager.characters.front()

	set_process(false)
	await world.initialization_finished
	
	if not player:
		spawn_player.call_deferred()

	post_init()
	set_process(true)


func post_init():
	pass


func pre_start():
	return true


func _process(_delta):
	if Input.is_action_just_pressed("toggle_free_cam"):
		camera.free_cam= not camera.free_cam
		player.freeze= camera.free_cam

	elif Input.is_action_just_pressed("toggle_fly"):
		cheats.fly= not cheats.fly


func spawn_player():
	assert(player_scene)
	assert(player == null)
	player= player_scene.instantiate()
	player.position= settings.player_spawn
	add_child.call_deferred(player)
	player.ready.connect(on_player_spawned)

	camera.follow_node= player

	player.tree_exited.connect(respawn if settings.respawn_on_death else game_over.bind(false))


func respawn():
	if is_inside_tree():
		spawn_player.call_deferred()


func on_player_spawned():
	pass


func game_over(win: bool):
	game_is_over.emit(win)
