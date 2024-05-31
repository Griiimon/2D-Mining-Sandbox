extends Node

@export var cloud_scene: PackedScene

@onready var clouds = $Clouds


func _ready():
	for i in 100:
		var cloud: Cloud= cloud_scene.instantiate()
		cloud.position= Vector2(randf_range(-5000, 5000), randf_range(-1000, -100))
		cloud.velocity.x= randf_range(1, 5)
		clouds.add_child(cloud)
