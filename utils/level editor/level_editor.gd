@tool
extends TileMap

@export_file() var tile_set_path



func _ready():
	load_tileset()


func load_tileset():
	tile_set= load(tile_set_path)
