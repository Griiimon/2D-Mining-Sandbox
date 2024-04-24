extends InventorySlot
class_name HotbarSlot

@onready var selection: TextureRect = $Selection

var selected: bool= false: set= set_selected



func set_selected(b: bool):
	selected= b
	selection.visible= selected
