@tool
extends TextEdit


func _can_drop_data(position, data):
	return editable and data.type == "files"


func _drop_data(position, data):
	for file: String in data.files:
		if text:
			if file in text.split("\n"):
				return
			text+= "\n"
		text+= file
