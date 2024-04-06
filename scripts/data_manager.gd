extends Node

var blocks: Array[Block]

# load all blocks from the resource folder
func _init():
	var folder: String= "res://resources/blocks/"
	var dir:= DirAccess.open(folder)
	
	for file in dir.get_files():
		var item= load(folder + file)
		blocks.append(item)
