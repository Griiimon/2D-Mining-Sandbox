extends PanelContainer
class_name HotbarSlot

var selected: bool= false:
	set(_selected):
		selected= _selected
		selection.visible= selected


@onready var selection: TextureRect = $Selection
@onready var texture_rect: TextureRect = $TextureRect
@onready var amount_label: Label = $MarginContainer/Amount


func set_item(inv_item: InventoryItem):
	if not inv_item.item:
		texture_rect.texture= null
	else:
		texture_rect.texture= inv_item.item.texture
		if inv_item.item.can_stack:
			amount_label.text= str(inv_item.amount)
			amount_label.show()
		else:
			amount_label.hide()
		
