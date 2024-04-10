class_name ChunkUpdater
extends Node

@export var chunk_viewer: Node2D
@export var min_distance: int= 100
@export var max_distance: int= 200


var world: World


func _ready():
	world= get_parent()


func run(non_blocking: bool= true):
	var view_tile_pos: Vector2i= chunk_viewer.global_position / World.TILE_SIZE if chunk_viewer else Vector2i.ZERO

	for x in range(view_tile_pos.x - max_distance, view_tile_pos.x + max_distance, WorldChunk.SIZE):
		for y in range(view_tile_pos.y - max_distance, view_tile_pos.y + max_distance, WorldChunk.SIZE):
			var pos:= Vector2i(x, y)
			var chunk_coords: Vector2i= world.get_chunk_coords_at(pos)
			var chunk: WorldChunk= world.get_chunk(chunk_coords)
			
			var distance: int= (view_tile_pos - pos).length()

			if not chunk and distance < min_distance:
				world.create_chunk(chunk_coords)
				if non_blocking:
					await get_tree().process_frame
			#elif chunk and distance > max_distance:
				#chunk.queue_free()


func _on_update_timer_timeout():
	run()
