extends Node

const TILE_SET_PATH= "res://resources/tile_set.tres"

@export var orig_tile_set: TileSet
@export_dir var blocks_path: String
@export var blocks_suffix: String
@export_dir var items_path: String
@export_dir var block_entities_path: String
@export_dir var crafting_recipe_path: String
@export_dir var furnace_recipe_path: String
@export_dir var mobs_path: String
@export var mobs_suffix: String
@export var fluid_library: FluidLibrary

@export_dir var scenarios_path
@export_dir var builtin_scenarios_path
@export_dir var characters_path

@export var sound_library: SoundLibrary
@export var material_sound_library: MaterialSoundLibrary

var tile_set: TileSet

var blocks: Array[Block]
var blocks_lookup: Dictionary

var block_entities: Array[BlockEntityDefinition]

var items: Array[Item]

var crafting_recipes: Array[CraftingRecipe]
var furnace_recipes: Dictionary

var mobs: Array[MobDefinition]

var builtin_scenarios: Array[PackedScene]
var scenarios: Array[PackedScene]
var characters: Array[PackedScene]



func _ready():
	if Engine.is_editor_hint():
		return

	sound_library.build()
	material_sound_library.build()

	load_resource_folder_into_array(blocks_path, blocks, blocks_suffix)
	
	for i in len(blocks):
		blocks_lookup[blocks[i]]= i


	load_resource_folder_into_array(items_path, items)

	load_resource_folder_into_array(block_entities_path, block_entities)

	load_resource_folder_into_array(crafting_recipe_path, crafting_recipes)

	load_resource_folder_into_dictionary(furnace_recipe_path, furnace_recipes, "ingredient")

	load_resource_folder_into_array(mobs_path, mobs, mobs_suffix)

	load_scenes_folder(characters_path, characters)
	
	load_scenes_folder(builtin_scenarios_path, builtin_scenarios)

	load_scenes_folder(scenarios_path, scenarios, builtin_scenarios_path)

	late_ready.call_deferred()


func late_ready():
	WorldChunk.create_tileset()
	fluid_library.build()


func load_resource_folder_into_array(folder: String, array: Array, suffix: String= ".tres"):
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


func load_scenes_folder(folder: String, array: Array[PackedScene], exclude_path: String= ""):
	folder+= "/"
	var dir:= DirAccess.open(folder)
	
	for sub_dir_name in dir.get_directories():
		var path: String= folder + sub_dir_name
		if path == exclude_path: continue
		
		var sub_dir: DirAccess= DirAccess.open(path)
		var scene_file_name: String= sub_dir_name.to_snake_case() + ".tscn"
		if sub_dir.file_exists(scene_file_name):
			array.append(load(path + "/" + scene_file_name))
		else:
			push_error("Can't find %s in %s" % [ scene_file_name, path])


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


func get_block_from_name(_name: String)-> Block:
	for block in blocks:
		if block.name == _name:
			return block
	push_warning("get_block_from_name(%s): cant find block" % [_name])
	return null
