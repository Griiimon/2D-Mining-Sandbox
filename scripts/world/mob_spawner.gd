class_name MobSpawner
extends WorldComponent



func start():
	$Timer.start()


func _on_timer_timeout():
	if not enabled: return
	
	var chunk: WorldChunk= world.get_chunks().pick_random()
	
	var tile: Vector2i= chunk.get_random_tile()
	
	var mob_def: MobDefinition= DataManager.mobs.pick_random()
	
	var spawner: MobSpawnerDefinition= mob_def.spawner
	
	if spawner.can_spawn(tile, world):
		world.spawn_mob(mob_def, tile)
