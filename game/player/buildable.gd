class_name Buildable

enum Type { BLOCK, ENTITY }

var type: Type
var ptr

func _init(_type: Type, _ptr):
	type= _type
	ptr= _ptr


func can_build(inventory: Inventory)-> bool:
	return inventory.has_ingredients(get_ingredients())


func get_ingredients()-> Array[InventoryItem]:
	match type:
		Type.BLOCK:
			return (ptr as ArtificialBlock).ingredients
		Type.ENTITY:
			return (ptr as BlockEntityDefinition).ingredients
	
	assert(false)
	return []


func get_display_name()-> String:
	match type:
		Type.BLOCK:
			return (ptr as ArtificialBlock).get_display_name()
		Type.ENTITY:
			return (ptr as BlockEntityDefinition).get_display_name()
	assert(false)
	return ""

