class_name BasePlayer
extends CharacterBody2D

signal break_block(block: Block)


const DROP_THROW_FORCE= 300
const FLY_SPEED_FACTOR= 4.0

@export var top_down_mode: bool= false

@export_category("Movement")
@export var speed: float = 200.0
@export var jump_velocity: float = -300.0
@export var mining_speed: float= 1.0
@export var swim_speed: float= 30.0
@export var swim_acceleration: float= 1.0
@export var swim_damping: float= 1

@export_category("Health")
@export var fall_damage_speed: float= 600
@export var fall_damage_scale: float= 0.5

@export_category("Misc")
@export var freeze: bool= false
@export var loadout: PlayerLoadout

@export_category("Components")
@export var body: Node2D
@export var look_pivot: Node2D
@export var main_hand: Hand
@export var interaction_area: Area2D

@export_category("Scenes")
@export var block_marker_scene: PackedScene
@export var block_breaker_scene: PackedScene
@export var virtual_thrower_scene: PackedScene
@export var mine_raycast_scene: PackedScene


@onready var ui: UI = $"Player UI"
@onready var low_tile_detector: TileDetector = $"Low Tile Detector"
@onready var mid_tile_detector: TileDetector = $"Mid Tile Detector"
@onready var collision_shape: CollisionShape2D  = $CollisionShape2D
@onready var health: HealthComponent = $"Health Component"
@onready var hurtbox = $"Hurt Box"
@onready var crafting: PlayerCrafting = $Crafting
@onready var vehicle_logic: PlayerVehicleLogic = $Vehicle

@onready var state_machine: PlayerStateMachine = $"State Machine"
@onready var coyote_timer: Timer = $"Coyote Timer"
@onready var jump_buffer_timer: Timer = $"Jump Buffer Timer"


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var ray_cast: RayCast2D

# rectangle to mark the block we are currently looking at
var block_marker: Sprite2D
# overlay to indicate the breaking progress of the currently mined block
var block_breaker: AnimatedSprite2D

var hand_item_obj: HandItemObject

var inventory: Inventory= Inventory.new()

# disable fall damage when spawned
var disable_fall_damage: bool= true

var active_effects: Array[PlayerEffect]

var in_vehicle: Vehicle

var has_jumped:= false


func _ready():
	assert_export_scenes()

	var game: Game= get_parent()
	assert(game)
	game.player= self

	assert(game.settings.top_down_mode == top_down_mode)

	ray_cast= mine_raycast_scene.instantiate()
	look_pivot.add_child(ray_cast)

	motion_mode= CharacterBody2D.MOTION_MODE_FLOATING if top_down_mode else CharacterBody2D.MOTION_MODE_GROUNDED

	inventory.update.connect(update_inventory)

	init_block_indicators()

	init_loadout()


func _process(_delta):
	if freeze: return

	var mouse_pos: Vector2= get_global_mouse_position()

	if not top_down_mode:
		if mouse_pos.x >= position.x:
			body.scale.x= 1
		else:
			body.scale.x= -1

	look_pivot.look_at(mouse_pos)


func _physics_process(delta):
	if freeze: return

	if in_vehicle:
		vehicle_logic.on_physics_process(delta)
	else:
		if state_machine.current_state.can_move:
			match top_down_mode:
				true:
					top_down_movement(delta)
				false:
					sidescroll_movement(delta)

	tick_effects()

	if Input.is_action_just_pressed("drop_item") and has_hand_object():
		drop_hand_item()


func sidescroll_movement(delta):
	if is_swimming():
		swim(delta)
		return

	if Global.game.cheats.fly:
		fly(delta)
		return


	if not is_on_floor():
		if low_tile_detector.is_in_fluid():
			velocity.y+= gravity / 20 * delta
		else:
			velocity.y+= gravity * delta

	var direction= Input.get_axis("left", "right")
	if direction:
		velocity.x= direction * get_max_speed()
	else:
		#velocity.x= move_toward(velocity.x, 0, speed)
		velocity.x= 0

	if is_on_floor():
		coyote_timer.start()
		coyote_timer.set_paused(true)
		has_jumped = false
		if jump_buffer_timer.time_left > 0:
			jump()
	else:
		coyote_timer.set_paused(false)

	if Input.is_action_just_pressed("jump"):
		if not has_jumped and coyote_timer.time_left > 0:
			jump()
		elif has_jumped:
			jump_buffer_timer.start()

	if is_on_floor():
		if abs(velocity.x) > 0:
			on_movement_walk()
		else:
			on_movement_stop()

	if not is_on_floor():
		var collision: KinematicCollision2D= move_and_collide(velocity * delta, true)
		if collision and collision.get_normal().dot(Vector2.UP) > 0:
			if not disable_fall_damage:
				NodeDebugger.write(self, str("fall speed ", velocity.y), 2)
				if velocity.y > fall_damage_speed:
					fall_damage()
			else:
				disable_fall_damage= false

	move_and_slide()


func top_down_movement(_delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction.length() > 0:
		velocity = direction.normalized() * get_max_speed() * 1.5
		on_movement_walk()
	else:
		velocity = Vector2.ZERO
		on_movement_stop()
	
	# Update look_pivot only if character should still face mouse
	var mouse_pos: Vector2 = get_global_mouse_position()
	look_pivot.look_at(mouse_pos)
	
	move_and_slide()


func jump():
	has_jumped = true
	velocity.y= get_jump_velocity()
	on_movement_jump()


func get_jump_velocity()-> float:
	var result: float= jump_velocity
	result*= get_effect_multiplier(PlayerEffect.Type.JUMP_FORCE)
	return result


func tick_effects():
	for effect in active_effects.duplicate():
		if not effect.tick():
			active_effects.erase(effect)


func on_movement_jump():
	pass


func on_movement_walk():
	pass


func on_movement_stop():
	pass


func swim(delta: float):
	on_swim()

	var direction= Input.get_axis("left", "right")
	if direction:
		velocity.x= move_toward(velocity.x, direction * swim_speed, swim_acceleration)

	if Input.is_action_pressed("jump"):
		velocity.y= -swim_speed
	elif Input.is_action_pressed("down") and not is_on_floor():
		velocity.y= swim_speed

	move_and_slide()

	velocity*= 1 - delta * swim_damping


func on_swim():
	pass


func fly(_delta: float):
	var direction: Vector2= Input.get_vector("left", "right", "up", "down")
	velocity= direction * speed * FLY_SPEED_FACTOR
	move_and_slide()


func on_hand_action(_action_name: String):
	pass


func release_charge(charge_primary: bool, total_charge: float):
	assert(has_hand_object())
	NodeDebugger.write(self, "release charge", 2)
	get_hand_object().release_charge(total_charge, charge_primary)
	hand_action_executed()


func equip_hand_item(item: HandItem):
	await unequip_hand_item()
	assert(not hand_item_obj and not has_hand_object())

	var obj_scene: PackedScene
	if item.type == HandItem.Type.THROWABLE:
		obj_scene= virtual_thrower_scene
	else:
		obj_scene= item.scene

	hand_item_obj= obj_scene.instantiate()
	main_hand.set_object(hand_item_obj)
	hand_item_obj.type= item
	hand_item_obj.on_equip()


func unequip_hand_item():
	if has_hand_object():
		get_hand_object().on_unequip()
		get_hand_object().queue_free()
		hand_item_obj= null
		await get_tree().process_frame


func hand_action_executed(action_name: String= "", primary: bool= true):
	if get_hand_object() is VirtualProjectileThrower:
		inventory.sub_item(get_current_inventory_item())
		if get_current_inventory_item().count > 0:
			get_hand_object().on_equip()
		else:
			get_hand_object().queue_free()

	if action_name:
		subscribe_hand_action_finished(action_name, hand_action_finished)
	else:
		hand_action_finished(action_name)

	get_hand_object().action(primary)


func hand_action_finished(_action_name: String= ""):
	on_hand_action_finished()
	if state_machine.current_state:
		state_machine.current_state.on_hand_action_finished()


func subscribe_hand_action_finished(_action_name: String, _method: Callable):
	assert(false, "Override this method in your custom character class")


func has_hand_object()-> bool:
	return main_hand.has_hand_object()


func get_hand_object()-> HandItemObject:
	return main_hand.get_hand_object()


func get_hand_object_type()-> HandItem.Type:
	if not has_hand_object():
		return HandItem.Type.NONE
	return get_hand_object().type.type


func drop_hand_item():
	assert(has_hand_object())
	var throw_velocity: Vector2= get_look_direction() * DROP_THROW_FORCE
	get_world().throw_item(get_hand_object().type, main_hand.global_position, throw_velocity)
	unequip_hand_item()
	inventory.clear_slot(ui.current_hotbar_slot_idx)


func can_pickup(item: Item)-> bool:
	return true


func pickup(item: Item):
	add_item_to_inventory(item)


func add_item_to_inventory(item: Item, count: int= 1):
	inventory.add_new_item(item, count)

	if not has_hand_object():
		check_hotbar_hand_item()


func get_current_inventory_item()-> InventoryItem:
	return inventory.items[get_current_inventory_slot()]


func get_current_inventory_slot()-> int:
	return ui.current_hotbar_slot_idx


func is_current_inventory_slot_empty()-> bool:
	return get_current_inventory_item().item == null


func update_hotbar():
	ui.update_hotbar()


func update_inventory():
	ui.update_inventory()


func get_look_direction()-> Vector2:
	var vec: Vector2= look_pivot.transform.x
	vec.x*= body.scale.x
	return vec


func get_world()-> World:
	return get_parent().world


func _on_player_ui_hotbar_slot_changed():
	await unequip_hand_item()
	check_hotbar_hand_item()


func check_hotbar_hand_item():
	var item: Item= get_current_inventory_item().item
	if item and item is HandItem:
		equip_hand_item(item)


func on_hand_action_finished():
	pass


func fall_damage():
	health.receive_damage(Damage.new((velocity.y - fall_damage_speed) * fall_damage_scale, Damage.Type.FALL))


func assert_export_scenes():
	assert(body)
	assert(look_pivot)
	assert(main_hand)
	assert(interaction_area)
	assert(block_breaker_scene)
	assert(block_marker_scene)
	assert(virtual_thrower_scene)
	assert(mine_raycast_scene)


func init_block_indicators():
	block_marker= block_marker_scene.instantiate()
	add_child(block_marker)
	block_marker.top_level= true
	block_marker.hide()

	block_breaker= block_breaker_scene.instantiate()
	add_child(block_breaker)
	block_breaker.top_level= true
	block_breaker.hide()


func on_start_mining(_action_name: String):
	pass


func on_stop_mining():
	pass


func is_swimming()-> bool:
	return low_tile_detector.is_in_fluid() and mid_tile_detector.is_in_fluid()


func get_max_speed()-> float:
	var result: float= speed

	if low_tile_detector.is_in_fluid() or mid_tile_detector.is_in_fluid():
		result/= 2

	result*= get_effect_multiplier(PlayerEffect.Type.MOVE_SPEED)

	return result


func get_tile_pos()-> Vector2i:
	return get_world().get_tile(global_position)


func get_tile_distance(tile: Vector2i)-> int:
	return int((get_tile_pos() - tile).length())


func die():
	state_machine.change_state(state_machine.dying_state)
	on_death()


func on_death():
	pass


func _on_crafting_recipe_crafted(recipe: CraftingRecipe):
	inventory.block_update_callback= true
	inventory.sub_ingredients(recipe.ingredients)
	inventory.block_update_callback= false
	add_item_to_inventory(recipe.product, recipe.product_count)


func init_loadout():
	var priority_loadout: PlayerLoadout= loadout
	if Global.game.settings.player_loadout:
		priority_loadout= Global.game.settings.player_loadout
	for inv_item in priority_loadout.inventory_items:
		add_item_to_inventory(inv_item.item, inv_item.count)


func init_death():
	freeze= true
	collision_shape.set_deferred("disabled", true)
	health.queue_free()
	hurtbox.queue_free()
	crafting.queue_free()
	ui.queue_free()


func craft(recipe: CraftingRecipe, count: int):
	crafting.add(recipe, count)
	ui.crafting_ui.build()


func play_hand_item_sound(target_material: MaterialSoundLibrary.Type):
	if not has_hand_object(): return
	PositionalSoundPlayer.play_material_sound(get_hand_object().type.material, target_material, get_hand_object().global_position)


func add_effect(effect: PlayerEffect):
	active_effects.append(effect)


func enter_vehicle_seat(seat: VehicleSeat):
	state_machine.paused= true
	in_vehicle= seat.get_vehicle()
	vehicle_logic.on_enter(seat)
	seat.get_vehicle().on_enter()


func get_effect_multiplier(type: PlayerEffect.Type):
	var result: float= 1
	for effect in active_effects:
		if effect.type == type:
			result*= effect.multiplier
	return result


func is_in_tile(tile_pos: Vector2i)-> bool:
	var query= PhysicsShapeQueryParameters2D.new()
	var shape:= RectangleShape2D.new()
	shape.size= Vector2.ONE * World.TILE_SIZE
	query.shape= shape
	query.transform.origin= get_world().map_to_local(tile_pos)
	query.collision_mask= Utils.build_mask([Global.PLAYER_COLLISION_LAYER])
	if get_world_2d().direct_space_state.intersect_shape(query):
		return true
	return false


func is_frozen()-> bool:
	return freeze
