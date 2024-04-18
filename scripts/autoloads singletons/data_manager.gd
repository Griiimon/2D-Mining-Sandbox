#@tool
extends Node

#const TILE_SET_PATH= "res://resources/tile_set.tres"
#const ORIG_TILE_SET_PATH= "res://resources/orig_tile_set.tres"

@export var tile_set: TileSet
@export var orig_tile_set: TileSet
@export_dir var blocks_path: String
@export var blocks_suffix: String
@export_dir var furnace_recipe_path: String
@export_dir var mobs_path: String
@export var mobs_suffix: String
@export var fluid_library: FluidLibrary


var blocks: Array[Block]
var blocks_lookup: Dictionary

var furnace_recipes: Dictionary


var mobs: Array[MobDefinition]

#var tile_set: TileSet



func _init():
	load_resource_folder_into_array(blocks_path, blocks, blocks_suffix)
	
	for i in len(blocks):
		blocks_lookup[blocks[i]]= i

	if Engine.is_editor_hint(): return

	load_resource_folder_into_dictionary(furnace_recipe_path, furnace_recipes, "ingredient")

	load_resource_folder_into_array(mobs_path, mobs, mobs_suffix)

	late_init.call_deferred()


func late_init():
	WorldChunk.create_tileset()
	fluid_library.build()


func load_resource_folder_into_array(folder: String, array: Array, suffix: String):
	#folder+= "/"
	#var dir:= DirAccess.open(folder)
	#
	#for file in dir.get_files():
		#var item= load(folder + file)
		#array.append(item)
	for file in Utils.load_directory_recursively(folder):
		if file.ends_with(suffix):
			array.append(load(file))


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
