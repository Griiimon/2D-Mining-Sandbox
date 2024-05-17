@tool
extends Control

@export var item_scene: PackedScene
@export var library: MaterialSoundLibrary


@onready var grid_container = %GridContainer

var items:= {}


func _ready():
	generate_grid()


func generate_grid():
	Utils.free_children(grid_container)
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
				var item: SoundMatrixItem= item_scene.instantiate()
				grid_container.add_child(item)
				if y > x:
					item.editable= false
				else:
					var key: String= get_key(x - 1, y - 1)
					if items.has(key):
						item.text= items[key]

					item.text_changed_or_dropped.connect(text_changed.bind(item, x - 1, y - 1))

			if label:
				grid_container.add_child(label)


func _on_button_load_pressed():
	items.clear()
	#print("Loading %d SoundMatrix items" % [len(library.sound_paths.keys())])
	for key in library.sound_paths.keys():
		items[key]= library.sound_paths[key]
	generate_grid()


func _on_button_save_pressed():
	library.sound_paths.clear()
	#print("Saving %d SoundMatrix items" % [len(items.keys())])
	for key: String in items.keys():
		library.sound_paths[key]= items[key]
	ResourceSaver.save(library)


func text_changed(item: TextEdit, x: int, y: int):
	#print("Update SoundMatrixItem [%d, %d] = %s" % [x, y, item.text])
	if not item.text:
		items.erase(get_key(x, y))
	else:
		items[get_key(x, y)]= item.text


func get_key(x: int, y: int)-> String:
	if y < x:
		var tmp= x
		x= y
		y= tmp
	return str(x, ",", y)
