extends CanvasLayer


const ENABLED= true

class DebugHUDItem:
	var name: String
	var value
	var label_value: Label

	func _init(_name: String, _value, _label: Label):
		name= _name
		value= _value
		label_value= _label

@onready var grid_container = %GridContainer

var dict: Dictionary


func send(key: String, value):
	if not ENABLED: return
	visible= true
	if not dict.has(key):
		var label_key= Label.new()
		label_key.text= key
		var label_value= Label.new()
		label_value.text= str(value)
		grid_container.add_child(label_key)
		grid_container.add_child(label_value)

		var item: DebugHUDItem= DebugHUDItem.new(key, value, label_value)
		dict[key]= item
		return
	
	dict[key].value= str(value)


func _process(delta):
	for key in dict.keys():
		dict[key].label_value.text= str(dict[key].value)
