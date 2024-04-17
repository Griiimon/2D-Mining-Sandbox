@tool
extends Node

const TILE_SET_PATH= "res://resources/tile_set.tres"
const ORIG_TILE_SET_PATH= "res://resources/orig_tile_set.tres"

var blocks: Array[Block]
var blocks_lookup: Dictionary

var furnace_recipes: Dictionary

var fluid_library: FluidLibrary

var tile_set: TileSet



func _init():
	load_resource_folder_into_array("res://resources/blocks", blocks)
	
	for i in len(blocks):
		blocks_lookup[blocks[i]]= i

	if Engine.is_editor_hint(): return

	load_resource_folder_into_dictionary("res://resources/recipes/furnace", furnace_recipes, "ingredient")

	fluid_library= load("res://resources/libraries/fluid_library.tres")

	late_init.call_deferred()


func late_init():
	WorldChunk.create_tileset()
	fluid_library.build()


func load_resource_folder_into_array(folder: String, array: Array):
	folder+= "/"
	var dir:= DirAccess.open(folder)
	
	for file in dir.get_files():
		var item= load(folder + file)
		array.append(item)


func load_resource_folder_into_dictionary(folder: String, dict: Dictionary, key: String):
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


func get_block(id: int)-> Block:
	assert(id < len(blocks))
	if id == -1:
		return null
	return blocks[id]


func get_block_id(block: Block)-> int:
	if not blocks_lookup.has(block):
		return -1
	return blocks_lookup[block]
