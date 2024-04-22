class_name UI
extends CanvasLayer

signal hotbar_slot_changed

@export var health: HealthComponent
@export var hotbar_slot_scene: PackedScene

@onready var hbox_hotbar = %"HBox Hotbar"
@onready var interaction_hint: Label= %"Interaction Hint"
@onready var health_bar: ProgressBar = %"ProgressBar Health"


var current_hotbar_slot_idx: int: set= set_current_hotbar_slot

var hurt_effect_tween: Tween



func _ready():
	for i in Inventory.SIZE:
		var slot: HotbarSlot= hotbar_slot_scene.instantiate()
		hbox_hotbar.add_child(slot)
		slot.selected= i == 0

	health.report_damage.connect(hurt_effect)


func _process(_delta):
	if Input.is_action_just_pressed("previous_hotbar_item"):
		current_hotbar_slot_idx-= 1
	elif Input.is_action_just_pressed("next_hotbar_item"):
		current_hotbar_slot_idx+= 1

	update_health()


func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				current_hotbar_slot_idx-= 1
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				current_hotbar_slot_idx+= 1

	elif event is InputEventKey:
		if event.is_pressed() and event.keycode >= KEY_1 and event.keycode <= KEY_9:
			current_hotbar_slot_idx= event.keycode - KEY_1


func update_health():
	var ratio: float= health.hitpoints / health.max_hitpoints
	if is_equal_approx(ratio, 1.0):
		health_bar.hide()
	else:
		health_bar.value= ratio * 100
		health_bar.show()


func hurt_effect(_damage, _hitpoints):
	if hurt_effect_tween and hurt_effect_tween.is_running():
		hurt_effect_tween.kill()
	hurt_effect_tween= create_tween()
	hurt_effect_tween.tween_property(health_bar, "modulate", Color.TRANSPARENT, 0.1)
	hurt_effect_tween.tween_property(health_bar, "modulate", Color.WHITE, 0.1)
	hurt_effect_tween.set_loops(3)


func select_current_hotbar_slot(enable: bool= true):
	var slot: HotbarSlot= hbox_hotbar.get_child(current_hotbar_slot_idx)
	slot.selected= enable


func update_hotbar(inventory: Inventory):
	for i in Inventory.SIZE:
		var slot: HotbarSlot= hbox_hotbar.get_child(i)
		slot.set_item(inventory.items[i])


func set_interaction_hint(text: String= "", pos: Vector2= Vector2.ZERO):
	interaction_hint.text= text
	interaction_hint.visible= not text.is_empty()

	await get_tree().process_frame
	interaction_hint.position= get_viewport().canvas_transform * pos - Vector2(interaction_hint.size.x / 2, 0)


func set_current_hotbar_slot(idx: int):
	select_current_hotbar_slot(false)
	current_hotbar_slot_idx= wrapi(idx, 0, 9)
	select_current_hotbar_slot()
	hotbar_slot_changed.emit()
