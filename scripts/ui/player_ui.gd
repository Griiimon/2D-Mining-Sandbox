class_name UI
extends CanvasLayer

signal hotbar_slot_changed

@export var hotbar_slot_scene: PackedScene

@onready var hbox_hotbar = %"HBox Hotbar"
@onready var interaction_hint: Label= %"Interaction Hint"


var current_hotbar_slot_idx: int:
	set(_slot):
		select_current_hotbar_slot(false)
		current_hotbar_slot_idx= wrapi(_slot, 0, 9)
		select_current_hotbar_slot()
		hotbar_slot_changed.emit()

func _ready():
	for i in Inventory.SIZE:
		var slot: HotbarSlot= hotbar_slot_scene.instantiate()
		hbox_hotbar.add_child(slot)
		slot.selected= i == 0


func _process(_delta):
	if Input.is_action_just_pressed("previous_hotbar_item"):
		current_hotbar_slot_idx-= 1
	elif Input.is_action_just_pressed("next_hotbar_item"):
		current_hotbar_slot_idx+= 1


func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				current_hotbar_slot_idx+= 1
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				current_hotbar_slot_idx-= 1
				


func select_current_hotbar_slot(enable: bool= true):
	var slot: HotbarSlot= hbox_hotbar.get_child(current_hotbar_slot_idx)
	slot.selected= enable


func update_hotbar(inventory: Inventory):
	for i in Inventory.SIZE:
		var slot: HotbarSlot= hbox_hotbar.get_child(i)
		slot.set_item(inventory.items[i])


func set_interaction_hint(text: String= ""):
	interaction_hint.text= text
