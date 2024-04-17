class_name TileDetector
extends Node2D

@export var active: bool= true

var current_tile: Vector2i
var current_block: Block


func _physics_process(_delta):
	current_tile= Global.game.world.get_tile(global_position)
	current_block= Global.game.world.get_block(current_tile)


func is_in_fluid()-> bool:
	return current_block and current_block.is_fluid
