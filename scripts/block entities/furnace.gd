class_name Furnace
extends BaseBlockEntity

@export var default_texture: Texture2D
@export var working_texture: Texture2D


var fuel: float
var ore_type: Item
var ore_amount: int

var product_type: Item
var product_amount: int

var is_burning: bool= false:
	set(b):
		if is_burning != b:
			is_burning= b
			sprite.texture= working_texture if is_burning else default_texture

var ticks_to_finish: float


func _ready():
	super()
	sprite.texture= default_texture


func tick(world: World):
	if is_burning:
		ticks_to_finish-= 1
		if ticks_to_finish == 0:
			NodeDebugger.msg(self, "product finished")
			product_amount+= 1
			is_burning= false
		else:
			return
			
	if ore_type and ore_amount > 0:
		var recipe: FurnaceRecipe= DataManager.find_furnace_recipe_for(ore_type)
		
		if fuel < recipe.required_fuel:
			return
		if product_type and product_type != recipe.product:
			return
		
		product_type= recipe.product
		fuel-= recipe.required_fuel
		ore_amount-= 1
		ticks_to_finish= recipe.duration * World.ENTITY_TICKS
		is_burning= true
	
		NodeDebugger.msg(self, "start recipe " + ore_type.name)


func interact(player: Player):
	if player.is_current_inventory_slot_empty() or player.get_current_inventory_item().item == product_type:
		if product_amount > 0:
			NodeDebugger.msg(self, "take product")
			player.inventory.add_item_to_slot(player.get_current_inventory_slot(), product_type)
			product_amount-= 1
	else:
		var inv_item: InventoryItem= player.get_current_inventory_item()
		if inv_item.item.fuel_value > 0:
			NodeDebugger.msg(self, "adding fuel")
			fuel+= inv_item.item.fuel_value
			player.inventory.sub_item(inv_item)
		else:
			var recipe: FurnaceRecipe= DataManager.find_furnace_recipe_for(inv_item.item)
			if recipe:
				if ore_type == null or ore_type == inv_item.item:
					NodeDebugger.msg(self, "adding ore")
					ore_type= inv_item.item
					ore_amount+= 1
					player.inventory.sub_item(inv_item)

