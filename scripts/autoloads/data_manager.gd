@tool
extends Node

const TILE_SET_PATH= "res://resources/tile_set.tres"
const ORIG_TILE_SET_PATH= "res://resources/orig_tile_set.tres"

var blocks: Array[Block]
var blocks_lookup: Dictionary

var furnace_recipes: Dictionary

var tile_set: TileSet



func _init():
	load_resource_folder_into_array("res://resources/blocks", blocks)
	
	for i in len(blocks):
		blocks_lookup[blocks[i]]= i

	if Engine.is_editor_hint(): return

	load_resource_folder_into_dictionary("res://resources/recipes/furnace", furnace_recipes, "ingredient")

	late_init.call_deferred()


func late_init():
	WorldChunk.create_tileset()


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


func get_block_id(block: Block)-> int:
	assert(blocks_lookup.has(block))
	return blocks_lookup[block]
