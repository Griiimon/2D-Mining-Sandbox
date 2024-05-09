class_name Furnace
extends BaseBlockEntity

@export var default_texture: Texture2D
@export var working_texture: Texture2D


var fuel: float
var ore_type: Item
var ore_count: int

var product_type: Item
var product_count: int

var is_burning: bool= false: set= set_burning

var ticks_to_finish: float


func _ready():
	super()
	sprite.texture= default_texture


func tick(_world: World):
	if is_burning:
		ticks_to_finish-= 1
		if ticks_to_finish == 0:
			NodeDebugger.write(self, "product finished")
			product_count+= 1
			is_burning= false
		else:
			return
			
	if ore_type and ore_count > 0:
		var recipe: FurnaceRecipe= DataManager.find_furnace_recipe_for(ore_type)
		
		if fuel < recipe.required_fuel:
			return
		if product_type and product_type != recipe.product:
			return
		
		product_type= recipe.product
		fuel-= recipe.required_fuel
		ore_count-= 1
		ticks_to_finish= recipe.duration * World.ENTITY_TICKS
		is_burning= true
	
		NodeDebugger.write(self, "start recipe " + ore_type.name)


func interact(player: BasePlayer):
	if can_player_take_product(player):
		if product_count > 0:
			NodeDebugger.write(self, "take product")
			player.inventory.add_item_to_slot(player.get_current_inventory_slot(), product_type)
			product_count-= 1
	else:
		var inv_item: InventoryItem= player.get_current_inventory_item()
		if can_player_add_fuel(player):
			NodeDebugger.write(self, "adding fuel")
			fuel+= inv_item.item.fuel_value
			player.inventory.sub_item(inv_item)
		else:
			var recipe: FurnaceRecipe= DataManager.find_furnace_recipe_for(inv_item.item)
			if recipe:
				if ore_type == null or ore_type == inv_item.item:
					NodeDebugger.write(self, "adding ore")
					ore_type= inv_item.item
					ore_count+= 1
					player.inventory.sub_item(inv_item)


func can_player_take_product(player: BasePlayer)-> bool:
	return player.is_current_inventory_slot_empty() or player.get_current_inventory_item().item == product_type


func can_player_add_fuel(player: BasePlayer)-> bool:
		var inv_item: InventoryItem= player.get_current_inventory_item()
		return inv_item.item and inv_item.item.fuel_value > 0


func can_player_add_ore(player: BasePlayer)-> bool:
	var inv_item: InventoryItem= player.get_current_inventory_item()
	var recipe: FurnaceRecipe= DataManager.find_furnace_recipe_for(inv_item.item)
	return recipe and ( ore_type == null or ore_type == inv_item.item )


func custom_interaction_hint(player: BasePlayer, default_hint: String)-> String:
	if can_player_take_product(player) and product_count > 0:
		return "Take Product (%d)" % [product_count]
	elif can_player_add_fuel(player):
		return "Add Fuel (%d)" % [fuel]
	elif can_player_add_ore(player):
		return "Add Ore (%d)" % [ore_count]
	elif is_burning:
		return "Wait for Product"
	
	return default_hint


func set_burning(b: bool):
	if is_burning != b:
		is_burning= b
		sprite.texture= working_texture if is_burning else default_texture	
