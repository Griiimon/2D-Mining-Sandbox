extends CanvasLayer


@onready var character_item_list = %"Character ItemList"



func _ready():
	get_tree().paused= false
	populate_lists()


func populate_lists():
	for character_scene in DataManager.characters:
		character_item_list.add_item(character_scene.resource_path.rsplit("/")[-1].trim_suffix(".tscn").capitalize())

	character_item_list.select(0)


func _on_close_button_pressed():
	get_tree().quit()
