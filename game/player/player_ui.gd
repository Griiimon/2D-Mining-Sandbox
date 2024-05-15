class_name UI
extends CanvasLayer

signal hotbar_slot_changed
signal select_buildable(buildable)


const HOTBAR_SIZE= 9

@export var health: HealthComponent
@export var hotbar_slot_scene: PackedScene
@export var inventory_slot_scene: PackedScene

@onready var player: BasePlayer= get_parent()
@onready var hbox_hotbar = %"HBox Hotbar"
@onready var interaction_hint: Label= %"Interaction Hint"
@onready var health_bar: ProgressBar = %"ProgressBar Health"
@onready var main_inventory = $"Inventory"
@onready var grid_container_inventory: GridContainer = %"GridContainer Inventory"
@onready var crafting_ui: CraftingUI = %"Crafting UI"
@onready var build_menu: BuildMenu = $"Build Menu"


var current_hotbar_slot_idx: int: set= set_current_hotbar_slot

var source_inventory_slot: int= -1

var hurt_effect_tween: Tween



func _ready():
	assert(player)
	assert(health)
	
	for i in HOTBAR_SIZE:
		var slot: HotbarSlot= hotbar_slot_scene.instantiate()
		hbox_hotbar.add_child(slot)
		slot.selected= i == 0
		slot.left_clicked.connect(set_source_inventory_slot.bind(i))
		slot.right_clicked.connect(transfer_inventory_item.bind(i))

	for i in Inventory.SIZE - HOTBAR_SIZE:
		var slot: InventorySlot= inventory_slot_scene.instantiate()
		grid_container_inventory.add_child(slot)
		slot.left_clicked.connect(set_source_inventory_slot.bind(i + HOTBAR_SIZE))
		slot.right_clicked.connect(transfer_inventory_item.bind(i + HOTBAR_SIZE))

	health.report_damage.connect(hurt_effect)
	
	%"Crafting UI".craft.connect(player.craft)
	
	main_inventory.hide()


func _process(_delta):
	if Input.is_action_just_pressed("previous_hotbar_item"):
		current_hotbar_slot_idx-= 1
	elif Input.is_action_just_pressed("next_hotbar_item"):
		current_hotbar_slot_idx+= 1

	if Input.is_action_just_pressed("toggle_inventory"):
		toggle_inventory_window()

	update_health()


func _unhandled_key_input(event):
	var key_event: InputEventKey= event
	if key_event.is_pressed() and key_event.keycode == KEY_ESCAPE:
		if are_windows_open():
			close_windows()
			get_viewport().set_input_as_handled()


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


func update_hotbar():
	for i in HOTBAR_SIZE:
		var slot: HotbarSlot= hbox_hotbar.get_child(i)
		slot.set_item(player.inventory.items[i])


func update_main_inventory():
	for i in Inventory.SIZE - HOTBAR_SIZE:
		var slot: InventorySlot= grid_container_inventory.get_child(i)
		slot.set_item(player.inventory.items[i + HOTBAR_SIZE])


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


func set_source_inventory_slot(idx: int):
	source_inventory_slot= idx


func transfer_inventory_item(target_idx: int):
	if source_inventory_slot < 0: return
	if source_inventory_slot == target_idx: return
	
	var source_item: InventoryItem= get_inventory_item(source_inventory_slot)
	if not source_item.item or not source_item.count:
		return
	
	var target_item: InventoryItem= get_inventory_item(target_idx)
	if target_item.item and (target_item.item != source_item.item or not target_item.item.can_stack):
		return

	target_item.item= source_item.item
	target_item.count+= source_item.count
	player.inventory.clear_item(source_item)
	update_inventory()


func get_inventory_item(idx: int)-> InventoryItem:
	return player.inventory.items[idx]
	

func update_inventory():
	update_hotbar()
	update_main_inventory()
	crafting_ui.build()


func toggle_inventory_window(): 
	if main_inventory.visible:
		close_inventory_window()
	else:
		close_windows()
		main_inventory.show()
		player.freeze= true


func close_inventory_window():
	main_inventory.hide()
	player.freeze= false


func toggle_build_menu():
	if build_menu.visible:
		close_build_menu()
	else:
		close_windows()
		build_menu.build_list(player)
		build_menu.show()
		player.freeze= true


func close_build_menu():
	build_menu.hide()
	player.freeze= false


func close_windows():
	close_build_menu()
	close_inventory_window()


func are_windows_open()-> bool:
	return build_menu.visible or main_inventory.visible


func _on_build_menu_select_buildable(buildable: Buildable):
	close_build_menu()
	select_buildable.emit(buildable)

	
