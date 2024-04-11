class_name Player
extends CharacterBody2D

const DROP_THROW_FORCE= 300

@export var speed = 300.0
@export var jump_velocity = -400.0
@export var mining_speed= 1.0
@export var freeze: bool= false

@export_category("Components")
@export var body: Node2D
@export var look_pivot: Node2D
@export var ray_cast: RayCast2D
@export var main_hand: Node2D
@export var interaction_area: Area2D

@export_category("Scenes")
@export var block_marker_scene: PackedScene
@export var block_breaker_scene: PackedScene


@onready var animation_player_hand = $"AnimationPlayer Hand"
@onready var animation_player_feet = $"AnimationPlayer Feet"

@onready var ui: UI= $"Player UI"


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# rectangle to mark the block we are currently looking at
var block_marker: Sprite2D
# overlay to indicate the breaking progress of the currently mined block
var block_breaker: AnimatedSprite2D

var is_mining: bool= false
var mining_progress: float

var hand_item_obj: HandItemObject

var inventory: Inventory= Inventory.new()


func _ready():
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
	add_item_to_inventory(load("res://resources/hand items/pickaxe.tres"))


func _process(_delta):
	if freeze: return
	
	var mouse_pos: Vector2= get_global_mouse_position()
	
	if mouse_pos.x >= position.x:
		body.scale.x= 1
	else:
		body.scale.x= -1

	look_pivot.look_at(mouse_pos)


func _physics_process(delta):
	if freeze: return

	movement(delta)
	interaction_logic()
	
	if Input.is_action_just_pressed("drop_item") and has_hand_item():
		drop_hand_item()
	
	
	is_mining= false
	
	if ray_cast.is_colliding():
		var block_pos: Vector2i= select_block()
		
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			if can_mine():
				is_mining= mining_logic(block_pos, delta)
			
	else:
		block_marker.hide()
	
	if not is_mining:
		mining_progress= 0
		block_breaker.hide()
		animation_player_hand.play("RESET")
		

func movement(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

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

	ui.set_interaction_hint(interaction_target.get_interaction_hint(self))

	if Input.is_action_just_pressed("interact"):
		interaction_target.interact(self)



func mining_logic(block_pos: Vector2i, delta)-> bool:
	mining_progress+= mining_speed * delta
	var block_hardness: float= get_world().get_block_hardness(block_pos)
	
	if mining_progress >= block_hardness or Global.game.cheats.instant_mine:
		get_world().break_block(block_pos)
		return false
	
	else:
		block_breaker.position= get_world().map_to_local(block_pos)
		var frames: int= block_breaker.sprite_frames.get_frame_count("default")
		block_breaker.frame= int(frames * mining_progress / block_hardness)
		block_breaker.show()
		animation_player_hand.play("Mine")
		
	return true


func select_block()-> Vector2i:
	var block_pos: Vector2i= get_world().get_tile(get_tile_collision())
		
	block_marker.position= get_world().map_to_local(block_pos)
	block_marker.show()
	
	return block_pos


func get_tile_collision()-> Vector2i:
	var point: Vector2= ray_cast.get_collision_point()
	
	# apply fix for collision rounding issue on tile border
	# by moving the collision point into the tile
	
	point+= -ray_cast.get_collision_normal() * 0.1

	return point


func equip_hand_item(item: HandItem):
	unequip_hand_item()
	hand_item_obj= item.scene.instantiate()
	main_hand.add_child(hand_item_obj)
	hand_item_obj.type= item


func unequip_hand_item():
	if has_hand_item():
		get_hand_item().queue_free()
		hand_item_obj= null


func has_hand_item()-> bool:
	return main_hand.get_child_count() > 0


func get_hand_item()-> HandItemObject:
	return main_hand.get_child(0)


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


func add_item_to_inventory(item: Item):
	inventory.add_new_item(item)

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
	unequip_hand_item()
	check_hotbar_hand_item()


func check_hotbar_hand_item():
	var item: Item= get_current_inventory_item().item
	if item and item is HandItem:
		equip_hand_item(item)
		
