@tool
class_name SoundMatrixItem
extends TextEdit

signal text_changed_or_dropped



func _can_drop_data(position, data):
	return editable and data.type == "files"


func _drop_data(position, data):
	for file: String in data.files:
		if text:
			if file in text.split("\n"):
				break
			text+= "\n"
		text+= file
	send_update()


func send_update():
	text_changed_or_dropped.emit()
