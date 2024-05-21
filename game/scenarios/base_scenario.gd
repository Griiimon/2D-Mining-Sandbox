extends Game
class_name BaseScenario


@export var description: String
@export var has_timer: bool= true
@export var countdown: int= 0


@onready var level_editor = $"Level Editor"
@onready var ui = $UI

var time: float



func _ready():
	set_process(false)
	super()


func pre_start():
	for tile_pos in level_editor.get_used_cells(WorldChunk.TERRAIN_LAYER):
		var block: Block= DataManager.get_block(level_editor.get_cell_source_id(WorldChunk.TERRAIN_LAYER, tile_pos))
		if block and not block.is_air:
			world.set_block(block, tile_pos, Block.get_state_from_alt(level_editor.get_cell_alternative_tile(WorldChunk.TERRAIN_LAYER, tile_pos)))
	
	level_editor.queue_free()
	return get_tree().process_frame


func start():
	set_process(true)


func _process(delta):
	time+= delta
	
	if has_timer and countdown and get_time() < 0:
		game_over(false)
		return
	
	if win_condition():
		win()
	elif lose_condition():
		lose()

func win_condition()-> bool:
	return false


func lose_condition()-> bool:
	return false


func win():
	game_over(true)


func lose():
	game_over(false)


func update_objectives(text: String):
	ui.update_objectives(text)


func get_time()-> float:
	if countdown > 0:
		return countdown - time
	else:
		return time


func _on_world_initialization_finished():
	start()
