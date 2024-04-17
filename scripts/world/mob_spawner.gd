class_name MobSpawner
extends WorldComponent



func start():
	$Timer.start()


func _on_timer_timeout():
	if not enabled: return
