extends Node

var blocks: Array[Block]
var furnace_recipes: Array[FurnaceRecipe]


func _init():
	load_resource_folder_into_array("res://resources/blocks", blocks)
	load_resource_folder_into_array("res://resources/recipes/furnace", furnace_recipes)


static func load_resource_folder_into_array(folder: String, array: Array):
	folder+= "/"
	var dir:= DirAccess.open(folder)
	
	for file in dir.get_files():
		var item= load(folder + file)
		array.append(item)
