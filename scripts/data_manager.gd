@tool
extends Node

var blocks: Array[Block]
var furnace_recipes: Dictionary


func _init():
	load_resource_folder_into_array("res://resources/blocks", blocks)
	load_resource_folder_into_dictionary("res://resources/recipes/furnace", furnace_recipes, "ingredient")


static func load_resource_folder_into_array(folder: String, array: Array):
	folder+= "/"
	var dir:= DirAccess.open(folder)
	
	for file in dir.get_files():
		var item= load(folder + file)
		array.append(item)


static func load_resource_folder_into_dictionary(folder: String, dict: Dictionary, key: String):
	folder+= "/"
	var dir:= DirAccess.open(folder)
	
	for file in dir.get_files():
		var item= load(folder + file)
		assert(key in item)
		dict[item.get(key)]= item


func find_furnace_recipe_for(ore: Item)-> FurnaceRecipe:
	if not furnace_recipes.has(ore):
		return null
	return furnace_recipes[ore]
