extends PanelContainer
class_name InventorySlot

signal left_clicked
signal right_clicked

@onready var texture_rect: TextureRect = $TextureRect
@onready var amount_label: Label = $MarginContainer/Amount



func set_item(inv_item: InventoryItem):
	if not inv_item.item:
		texture_rect.texture= null
		amount_label.hide()
	else:
		texture_rect.texture= inv_item.item.texture
		if inv_item.item.can_stack:
			amount_label.text= str(inv_item.amount)
			amount_label.show()
		else:
			amount_label.hide()


func _on_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			left_clicked.emit()
		else:
			right_clicked.emit()
