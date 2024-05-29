extends PanelContainer
class_name InventorySlot

signal left_clicked
signal right_clicked

@onready var texture_rect: TextureRect = %TextureRect
@onready var amount_label: Label = $MarginContainer/Amount


var click_tween: Tween



func set_item(inv_item: InventoryItem):
	if not inv_item.item:
		texture_rect.texture= null
		amount_label.hide()
	else:
		texture_rect.texture= inv_item.item.texture
		if inv_item.item.can_stack:
			amount_label.text= str(inv_item.count)
			amount_label.show()
		else:
			amount_label.hide()


func _on_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT and can_click():
			if has_item():
				start_tween(Color.SEA_GREEN)
			else:
				start_tween(Color.SALMON)
			left_clicked.emit()

		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if has_item():
				start_tween(Color.SALMON)
			else:
				start_tween(Color.SEA_GREEN)
			right_clicked.emit()


func start_tween(color: Color):
	if click_tween and click_tween.is_running():
		click_tween.kill()

	click_tween= create_tween()
	modulate= color
	click_tween.tween_property(self, "modulate", Color.WHITE, 0.2)


func has_item()-> bool:
	return texture_rect.texture != null

func can_click()-> bool:
	return true
