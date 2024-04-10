@tool
extends Node

const TILE_SET_PATH= "res://resources/tile_set.tres"
const ORIG_TILE_SET_PATH= "res://resources/orig_tile_set.tres"

var blocks: Array[Block]
var furnace_recipes: Dictionary

var tile_set: TileSet



func _init():
	load_resource_folder_into_array("res://resources/blocks", blocks)

	create_tileset()

	if Engine.is_editor_hint(): return
	
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


# creates a tile-set automatically from block textures
func create_tileset():
	tile_set= load(ORIG_TILE_SET_PATH).duplicate()

	var collision_polygon:= [Vector2(0, 0), Vector2(World.TILE_SIZE, 0), Vector2(World.TILE_SIZE, World.TILE_SIZE),  Vector2(0, World.TILE_SIZE)]

	for i in collision_polygon.size():
		collision_polygon[i]= collision_polygon[i] - Vector2.ONE * World.TILE_SIZE / 2

	for block in blocks:
		var source:= TileSetAtlasSource.new()
		source.texture_region_size= Vector2i.ONE * World.TILE_SIZE
		source.texture= block.texture
		source.create_tile(Vector2i.ZERO)
		tile_set.add_source(source)
		
		if block.has_collision:
			var tile_data: TileData= source.get_tile_data(Vector2i.ZERO, 0)
			tile_data.add_collision_polygon(0)
			tile_data.set_collision_polygon_points(0, 0, collision_polygon)


	ResourceSaver.save(tile_set, TILE_SET_PATH)
