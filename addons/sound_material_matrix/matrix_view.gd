@tool
extends Control

@export var item_scene: PackedScene
@export var library: MaterialSoundLibrary


@onready var grid_container = %GridContainer

var items:= {}


func _ready():
	generate_grid()


func generate_grid():
	var matrix_size: int= MaterialSoundLibrary.Type.size() + 1
	grid_container.columns= matrix_size
	
	for y in matrix_size:
		for x in matrix_size:
			var label: Label
			label= Label.new()
			if x == 0 and y == 0:
				pass
			elif y == 0:
				label.text= MaterialSoundLibrary.Type.keys()[x - 1]
			elif x == 0:
				label.text= MaterialSoundLibrary.Type.keys()[y - 1]
			else:
				label= null
				var item: TextEdit= item_scene.instantiate()
				grid_container.add_child(item)
				if y > x:
					item.editable= false
				else:
					var key: String= get_key(x, y)
					if items.has(key):
						item.text= items[key]

				item.text_changed.connect(text_changed.bind(item, x, y))

			if label:
				grid_container.add_child(label)


func _on_button_load_pressed():
	print("Loading %d items" % [len(library.sound_paths.keys())])
	for key in library.sound_paths.keys():
		items[key]= library.sound_paths[key]


func _on_button_save_pressed():
	print("Saving %d items" % [len(items.keys())])
	for key in items.keys():
		library.sound_paths[key]= items[key]
	ResourceSaver.save(library)


func text_changed(item: TextEdit, x: int, y: int):
	print("Update item [%d, %d] = %s" % [x, y, item.text])
	items[get_key(x, y)]= item.text


func get_key(x: int, y: int)-> String:
	return str(x, ",", y)
