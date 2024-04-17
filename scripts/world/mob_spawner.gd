class_name MobSpawner
extends WorldComponent

@export var min_player_distance: int= 50

func start():
	$Timer.start()


func _on_timer_timeout():
	if not enabled: return
	
	var tile: Vector2i
	
	while true:
		var chunk: WorldChunk= world.get_chunks().pick_random()
		tile= chunk.get_random_tile()
		if Global.game.player.get_tile_distance(tile) > min_player_distance:
			break
	
	var mob_def: MobDefinition= DataManager.mobs.pick_random()
	
	var spawner: MobSpawnerDefinition= mob_def.spawner
	
	if spawner.can_spawn(tile, world):
		world.spawn_mob(mob_def, tile)
