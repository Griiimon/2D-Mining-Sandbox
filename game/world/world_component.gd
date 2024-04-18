class_name WorldComponent
extends Node


@export var enabled: bool= true


var world: World



func _ready():
	world= get_parent()
	late_ready.call_deferred()


func late_ready():
	pass


func start():
	pass
