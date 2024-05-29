extends CanvasLayer


@export var enabled: bool= false

class DebugHUDItem:
	var name: String
	var value
	var label_value: Label

	func _init(_name: String, _value, _label: Label):
		name= _name
		value= _value
		label_value= _label

@onready var grid_container = %GridContainer
@onready var labels = $Labels

var dict: Dictionary


func _ready():
	set_process(enabled)


func send(key: String, value):
	if not enabled: return
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


func _process(_delta):
	for key in dict.keys():
		dict[key].label_value.text= str(dict[key].value)


func add_global_label(pos: Vector2, text: String, keep: float= -1, color: Color= Color.WHITE):
	var label:= Label.new()
	label.text= text
	label.modulate= color

	label.position= get_viewport().canvas_transform * pos
	
	labels.add_child(label)
	
	if keep > 0:
		await get_tree().create_timer(keep).timeout
		label.queue_free()


func clear_labels():
	for child in labels.get_children():
		child.queue_free()
