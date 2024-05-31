class_name MobSpawner
extends WorldComponent

@export var min_player_distance: int= 50



func start():
	$Timer.start()


func _on_timer_timeout():
	if not enabled: return
	
	var tile: Vector2i
	
	var safe_ctr:= 0
	while safe_ctr < 50:
		var chunk: WorldChunk= world.get_chunks().pick_random()
		tile= chunk.get_random_tile()
		if Global.game.player.get_tile_distance(tile) > min_player_distance:
			break
		safe_ctr+= 1

	var mob_def: MobDefinition= DataManager.mobs.pick_random()
	var spawner: MobSpawnerDefinition= mob_def.spawner
	
	if spawner and spawner.can_spawn(tile, world):
		var other_mob: BaseMob= get_world().get_closest_mob(tile)
		if other_mob:
			var dist: float= other_mob.distance_to_tile(tile)
			if dist < spawner.min_distance_to_other:
				return
			elif other_mob.type == mob_def and dist < spawner.min_distance_to_same:
				return
			
			other_mob= get_world().get_closest_mob(tile, mob_def)
			if dist < spawner.min_distance_to_same:
				return

		
		world.spawn_mob(mob_def, tile)


func get_world()-> World:
	return get_parent()
