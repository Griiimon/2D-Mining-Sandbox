extends Game
class_name BaseScenario


@onready var level_editor = $"Level Editor"




func pre_start():
	for tile_pos in level_editor.get_used_cells(WorldChunk.TERRAIN_LAYER):
		var block: Block= DataManager.get_block(level_editor.get_cell_source_id(WorldChunk.TERRAIN_LAYER, tile_pos))
		if block and not block.is_air:
			world.set_block(block, tile_pos, Block.get_state_from_alt(level_editor.get_cell_alternative_tile(WorldChunk.TERRAIN_LAYER, tile_pos)))
	
	level_editor.queue_free()
	return get_tree().process_frame
