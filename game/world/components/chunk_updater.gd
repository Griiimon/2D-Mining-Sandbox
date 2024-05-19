class_name ChunkUpdater
extends WorldComponent

signal initial_run_completed

const DELAY_FRAMES= 10

@export var chunk_viewer: Node2D
@export var min_distance: int= 100
@export var max_distance: int= 200


var busy:= false



func late_ready():
	if not chunk_viewer:
		chunk_viewer= get_viewport().get_camera_2d()
	run(false)
	initial_run_completed.emit()


func start():
	$"Update Timer".start()


func run(non_blocking: bool= true):
	if not enabled or busy: return
	
	busy= true
	
	var view_tile_pos: Vector2i= Vector2i(chunk_viewer.global_position / World.TILE_SIZE) if chunk_viewer else Vector2i.ZERO

	for chunk: WorldChunk in world.get_chunks():
		var distance: int= int((view_tile_pos - chunk.get_world_tile_pos_center()).length())
		if distance > max_distance:
			if chunk.has_changes:
				world.chunk_storage[str(chunk.coords)]= chunk.save()
			chunk.cleanup()
			chunk.queue_free()


	for x in range(view_tile_pos.x - max_distance, view_tile_pos.x + max_distance, WorldChunk.SIZE):
		for y in range(view_tile_pos.y - max_distance, view_tile_pos.y + max_distance, WorldChunk.SIZE):
			var pos:= Vector2i(x, y)
			var chunk_coords: Vector2i= world.get_chunk_coords_at(pos)
			var chunk: WorldChunk= world.get_chunk(chunk_coords)
			
			var distance: int= int((view_tile_pos - pos).length())

			if not chunk and distance < min_distance:
				world.create_chunk(chunk_coords, world.get_chunk_storage(chunk_coords))
				if non_blocking:
					for i in DELAY_FRAMES:
						await get_tree().process_frame
	
	DebugHud.send("Total chunks", len(world.get_chunks()))
	busy= false


func _on_update_timer_timeout():
	if is_inside_tree():
		run()
