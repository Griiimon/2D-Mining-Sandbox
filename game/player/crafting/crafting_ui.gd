extends MarginContainer
class_name CraftingUI

signal craft(recipe, amount)

@export var craft_list_item_scene: PackedScene

@onready var vbox_list = %"VBoxContainer Crafting List"
@onready var vbox_ingredients = %"VBoxContainer Crafting Ingredients"
@onready var button_craft: Button = %"Button Craft"
@onready var spinbox_products: SpinBox = %"SpinBox Products"

var selected_item: CraftingListItem


func _ready():
	build()


func build():
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
	button_craft.disabled= false


func _on_button_craft_pressed():
	craft.emit(selected_item.recipe, spinbox_products.value)
