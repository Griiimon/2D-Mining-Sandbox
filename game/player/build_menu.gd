extends CenterContainer
class_name BuildMenu

class Buildable:
	enum Type { Block, Entity }

	var type: Type
	var ptr

	func _init(_type: Type, _ptr):
		type= _type
		ptr= _ptr


@onready var item_list = %ItemList


var buildables: Array[Buildable]


func init(player: BasePlayer):
	buildables.clear()
	
	for block in DataManager.blocks:
		if block is ArtificialBlock:
			buildables.append(Buildable.new(Buildable.Type.Block, block))

	for entity in DataManager.block_entities:
		buildables.append(Buildable.new(Buildable.Type.Entity, entity))
