class_name Player
extends CharacterBody2D

const DROP_THROW_FORCE= 300

@export var speed = 300.0
@export var jump_velocity = -400.0
@export var mining_speed= 1.0
@export var freeze: bool= false
@export var loadout: PlayerLoadout

@export_category("Components")
@export var body: Node2D
@export var look_pivot: Node2D
@export var ray_cast: RayCast2D
@export var main_hand: Node2D
@export var interaction_area: Area2D

@export_category("Scenes")
@export var block_marker_scene: PackedScene
@export var block_breaker_scene: PackedScene
@export var virtual_thrower_scene: PackedScene


@onready var animation_player_hand = $"AnimationPlayer Hand"
@onready var animation_player_feet = $"AnimationPlayer Feet"

@onready var ui: UI= $"Player UI"


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# rectangle to mark the block we are currently looking at
var block_marker: Sprite2D
# overlay to indicate the breaking progress of the currently mined block
var block_breaker: AnimatedSprite2D

var is_mining: bool= false:
	set(b):
		if b == is_mining: return
		is_mining= b
		if not is_mining:
			mining_progress= 0
			block_breaker.hide()
			animation_player_hand.play("RESET")
		else:
			block_breaker.show()
			animation_player_hand.play("mine")

var mining_progress: float

var selected_block_pos: Vector2i

var hand_item_obj: HandItemObject

var is_executing_action: bool= false

var inventory: Inventory= Inventory.new()

var is_charging: bool= false
var charge_primary: bool= true
var total_charge: float


func _ready():
	assert(body)
	assert(look_pivot)
	assert(ray_cast)
	assert(main_hand)
	assert(interaction_area)
	assert(block_breaker_scene)
	assert(block_marker_scene)
	assert(virtual_thrower_scene)
	
	var game: Game= get_parent()
	assert(game)
	game.player= self
	
	inventory.update_callback= update_hotbar
	
	block_marker= block_marker_scene.instantiate()
	add_child(block_marker)
	block_marker.top_level= true
	block_marker.hide()
	
	block_breaker= block_breaker_scene.instantiate()
	add_child(block_breaker)
	block_breaker.top_level= true
	block_breaker.hide()

	late_ready.call_deferred()


func late_ready():
	var priority_loadout: PlayerLoadout= loadout
	if Global.game.settings.player_loadout:
		priority_loadout= Global.game.settings.player_loadout
	for inv_item in priority_loadout.inventory_items:
		add_item_to_inventory(inv_item.item, inv_item.amount)


func _process(_delta):
	if freeze: return
	
	var mouse_pos: Vector2= get_global_mouse_position()
	
	if mouse_pos.x >= position.x:
		body.scale.x= 1
	else:
		body.scale.x= -1

	look_pivot.look_at(mouse_pos)


func _physics_process(delta):
	if is_charging:
		total_charge+= delta

	if freeze: return

	movement(delta)
	interaction_logic()
	
	if Input.is_action_just_pressed("drop_item") and has_hand_item():
		drop_hand_item()

	
	if ray_cast.is_colliding() and is_raycast_hitting_terrain():
		select_block()
		
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			if can_mine():
				is_mining= mining_logic(delta)
		else:
			is_mining= false
	else:
		block_marker.hide()
		is_mining= false
		
		mouse_actions()


func movement(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		animation_player_feet.play("jump")
	elif is_on_floor():
		if abs(velocity.x) > 0:
			animation_player_feet.play("Walk")
		else:
			animation_player_feet.play("RESET")

	move_and_slide()


func interaction_logic():
	var areas: Array[Area2D]= interaction_area.get_overlapping_areas()

	if areas.is_empty(): 
		ui.set_interaction_hint()
		return
	
	var interaction_target: InteractionTarget= areas[0]

	ui.set_interaction_hint(interaction_target.get_interaction_hint(self), interaction_target.label_offset.global_position)

	if Input.is_action_just_pressed("interact"):
		interaction_target.interact(self)


func mining_logic(delta)-> bool:
	mining_progress+= mining_speed * delta
	var block: Block= get_world().get_block(selected_block_pos)
	if not block:
		return false

	var total_mining_effort= block.hardness
	if get_hand_item_type() != block.mining_tool:
		total_mining_effort*= 1 + block.other_tool_penalty
		
	if mining_progress >= total_mining_effort or Global.game.cheats.instant_mine:
		get_world().break_block(selected_block_pos, get_hand_item_type() == block.mining_tool)
		return false
	else:
		block_breaker.position= get_world().map_to_local(selected_block_pos)
		var frames: int= block_breaker.sprite_frames.get_frame_count("default")
		block_breaker.frame= int(frames * mining_progress / total_mining_effort)
		
	return true


func mouse_actions():
	if is_charging:
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and not Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			release_charge()
	elif not is_executing_action:
		if has_hand_item():
			var action_name: String
			var hand_item_type: HandItem= get_hand_item().type
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				action_name= hand_item_type.primary_action_animation
				if hand_item_type.charge_primary_action:
					is_charging= true
					charge_primary= true
			elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
				action_name= hand_item_type.secondary_action_animation
				if hand_item_type.charge_secondary_action:
					is_charging= true
					charge_primary= false

			if action_name:
				animation_player_hand.play(action_name)
				is_executing_action= true


func select_block():
	var new_block_pos: = get_world().get_tile(get_tile_collision())
	if new_block_pos != selected_block_pos:
		mining_progress= 0
	selected_block_pos= new_block_pos
	
	block_marker.position= get_world().map_to_local(selected_block_pos)
	block_marker.show()


func release_charge():
	assert(has_hand_item())
	get_hand_item().release_charge(total_charge, charge_primary)
	is_charging= false
	total_charge= 0


func is_raycast_hitting_terrain()-> bool: 
	if ray_cast.get_collider() is TileMap:
		return true
	return false


func get_tile_collision()-> Vector2:
	var point: Vector2= ray_cast.get_collision_point()
	
	# apply fix for collision rounding issue on tile border
	# by moving the collision point into the tile
	
	point+= -ray_cast.get_collision_normal() * 0.1
	DebugHud.send("fixed tile collision", str(point))
	return point


func equip_hand_item(item: HandItem):
	await unequip_hand_item()
	assert(not hand_item_obj and main_hand.get_child_count() == 0)
	var obj_scene: PackedScene
	if item.type == HandItem.Type.THROWABLE:
		obj_scene= virtual_thrower_scene 
	else:
		obj_scene= item.scene

	hand_item_obj= obj_scene.instantiate()
	main_hand.add_child(hand_item_obj)
	hand_item_obj.type= item
	hand_item_obj.on_equip()


func unequip_hand_item():
	if has_hand_item():
		get_hand_item().queue_free()
		hand_item_obj= null
		await get_tree().process_frame


func has_hand_item()-> bool:
	return main_hand.get_child_count() > 0


func get_hand_item()-> HandItemObject:
	return main_hand.get_child(0)


func get_hand_item_type()-> HandItem.Type:
	if not has_hand_item():
		return HandItem.Type.NONE
	return get_hand_item().type.type


func can_mine()-> bool:
	return not has_hand_item() or get_hand_item().can_mine()


func drop_hand_item():
	assert(has_hand_item())
	var throw_velocity: Vector2= get_look_direction() * DROP_THROW_FORCE
	get_world().throw_item(get_hand_item().type, main_hand.global_position, throw_velocity)
	unequip_hand_item()
	inventory.clear_slot(ui.current_hotbar_slot_idx)


func can_pickup(item: Item)-> bool:
	return true


func pickup(item: Item):
	add_item_to_inventory(item)


func add_item_to_inventory(item: Item, amount: int= 1):
	inventory.add_new_item(item, amount)
	
	if not has_hand_item():
		check_hotbar_hand_item()


func get_current_inventory_item()-> InventoryItem:
	return inventory.items[get_current_inventory_slot()]


func get_current_inventory_slot()-> int:
	return ui.current_hotbar_slot_idx


func is_current_inventory_slot_empty()-> bool:
	return get_current_inventory_item().item == null


func update_hotbar():
	ui.update_hotbar(inventory)


func get_look_direction()-> Vector2:
	var vec: Vector2= look_pivot.transform.x
	vec.x*= body.scale.x
	return vec


func get_world()-> World:
	return get_parent().world


func _on_player_ui_hotbar_slot_changed():
	is_mining= false
	await unequip_hand_item()
	check_hotbar_hand_item()


func check_hotbar_hand_item():
	var item: Item= get_current_inventory_item().item
	if item and item is HandItem:
		equip_hand_item(item)


func _on_animation_player_hand_animation_finished(anim_name):
	is_executing_action= false
