extends MarginContainer
class_name CraftingUI

signal craft(recipe, count)

@export var craft_list_item_scene: PackedScene

@onready var vbox_list = %"VBoxContainer Crafting List"
@onready var vbox_ingredients = %"VBoxContainer Crafting Ingredients"
@onready var button_craft: Button = %"Button Craft"
@onready var spinbox_products: SpinBox = %"SpinBox Products"

var selected_item: CraftingListItem



func build():
	for child in vbox_list.get_children():
		child.free()

	for recipe in DataManager.crafting_recipes:
		var item: CraftingListItem= craft_list_item_scene.instantiate()
		vbox_list.add_child(item)
		item.init(recipe, Global.game.player)
		item.selected.connect(select_item.bind(item))


func select_item(item: CraftingListItem):
	selected_item= item
	for child: CraftingListItem in vbox_list.get_children():
		if child != selected_item:
			child.deselet()
	
	set_ingredients(item.recipe)
	
	button_craft.disabled= false


func set_ingredients(recipe: CraftingRecipe):
	Utils.free_children(vbox_ingredients)
	for ingredient in recipe.ingredients:
		var label:= Label.new()
		label.text= "%dx %s" % [ingredient.count, ingredient.item.get_display_name()]
		vbox_ingredients.add_child(label)


func _on_button_craft_pressed():
	craft.emit(selected_item.recipe, spinbox_products.value)


func _on_visibility_changed():
	if Utils.is_starting(): return
	if visible:
		build()
