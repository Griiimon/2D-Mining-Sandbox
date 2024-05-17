extends CanvasLayer


@onready var character_item_list = %"Character ItemList"
@onready var game_mode_item_list = %"Game Mode ItemList"
@onready var seed_line_edit = %"Seed LineEdit"



func _ready():
	get_tree().paused= false
	
	if GameManager.world_seed:
		seed_line_edit.text= GameManager.world_seed
	
	populate_lists()


func populate_lists():
	for character_scene in DataManager.characters:
		character_item_list.add_item(get_scene_name(character_scene))

	character_item_list.select(0)

	for scenario in DataManager.builtin_scenarios + DataManager.scenarios:
		game_mode_item_list.add_item(get_scene_name(scenario))

	game_mode_item_list.select(0)


func get_scene_name(scene: PackedScene)-> String:
	return scene.resource_path.rsplit("/")[-1].trim_suffix(".tscn").capitalize()


func _on_close_button_pressed():
	get_tree().quit()


func _on_play_button_pressed():
	GameManager.world_seed= seed_line_edit.text
	GameManager.character= DataManager.characters[character_item_list.get_selected_items()[0]]
	var scenarios: Array[PackedScene]= DataManager.builtin_scenarios + DataManager.scenarios
	GameManager.run_game(scenarios[game_mode_item_list.get_selected_items()[0]])
