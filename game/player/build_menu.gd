extends Control
class_name BuildMenu

class Buildable:
	enum Type { Block, Entity }

	var type: Type
	var ptr

	func _init(_type: Type, _ptr):
		type= _type
		ptr= _ptr


	func can_build(inventory: Inventory)-> bool:
		var ingredients: Array[InventoryItem]
		match type:
			Type.Block:
				ingredients= (ptr as ArtificialBlock).ingredients
			Type.Entity:
				ingredients= (ptr as BlockEntityDefinition).ingredients

		return inventory.has_ingredients(ingredients)


	func get_display_name()-> String:
		match type:
			Type.Block:
				return (ptr as ArtificialBlock).get_display_name()
			Type.Entity:
				return (ptr as BlockEntityDefinition).get_display_name()
		assert(false)
		return ""



@onready var item_list = %ItemList


var buildables: Array[Buildable]


func _ready():
	init()


func init():
	buildables.clear()
	
	for block in DataManager.blocks:
		if block is ArtificialBlock:
			buildables.append(Buildable.new(Buildable.Type.Block, block))

	for entity in DataManager.block_entities:
		buildables.append(Buildable.new(Buildable.Type.Entity, entity))


func build_list(player: BasePlayer):
	item_list.clear()
	
	for buildable in buildables:
		item_list.add_item(buildable.get_display_name())
