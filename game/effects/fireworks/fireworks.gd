class_name Fireworks
extends Node2D

@export var effect_scene: PackedScene
@export var count: int= 20
@export var interval: float = 0.2
@export var max_distance: int= 500

@onready var next_effect: float= interval
@onready var effects_left: int= count


func _process(delta):

	next_effect-= delta
	
	if next_effect <= 0:
		var obj= effect_scene.instantiate()
		obj.position= Vector2(randi_range(-max_distance, max_distance), randi_range(-max_distance, max_distance))
		add_child(obj)
		next_effect= interval

		effects_left-= 1
		if effects_left <= 0:
			set_process(false)
			await get_tree().create_timer(5).timeout
			queue_free()
		else:
			if Utils.chance100(20):
				SoundPlayer.play("fireworks")
