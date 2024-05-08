extends MarginContainer
class_name CraftingUI

signal craft(recipe, count)

@export var craft_list_item_scene: PackedScene

@onready var list = %"VBoxContainer Crafting List"
@onready var ingredients_panel = %Ingredients
@onready var ingredients = %"VBoxContainer Crafting Ingredients"
@onready var button_craft: Button = %"Button Craft"
@onready var spinbox_products: SpinBox = %"SpinBox Products"

var selected_item: CraftingListItem



func build():
	selected_item= null
	button_craft.disabled= true

	Utils.free_children(list)

	for recipe in DataManager.crafting_recipes:
		var item: CraftingListItem= craft_list_item_scene.instantiate()
		list.add_child(item)
		item.init(recipe, Global.game.player)
		item.selected.connect(select_item.bind(item))

	ingredients_panel.hide()


func select_item(item: CraftingListItem):
	selected_item= item
	for child: CraftingListItem in list.get_children():
		if child != selected_item:
			child.deselect()
	
	set_ingredients(item.recipe)
	
	button_craft.disabled= false


func set_ingredients(recipe: CraftingRecipe):
	Utils.free_children(ingredients)
	Utils.make_ingredient_list(ingredients, recipe.ingredients)
	ingredients_panel.show()


func _on_button_craft_pressed():
	if selected_item and is_instance_valid(selected_item):
		craft.emit(selected_item.recipe, spinbox_products.value)


func _on_visibility_changed():
	# to avoid it being triggered when instantiated
	await get_tree().process_frame

	if visible:
		build()
