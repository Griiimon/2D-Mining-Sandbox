extends PanelContainer
class_name CraftingListItem

signal selected

@onready var label = $MarginContainer/Label

var recipe: CraftingRecipe
var available: bool= false


func init(_recipe: CraftingRecipe, player: BasePlayer):
	recipe= _recipe
	update(player)


func _on_gui_input(event):
	if not available: return
	
	if event in InputEventMouseButton:
		if event.pressed:
			select()


func select():
	modulate= Color.WHITE
	selected.emit()


func deselect():
	modulate= Color.WEB_GRAY


func update(player: BasePlayer):
	label.modulate= Color.WHITE if player.inventory.has_ingredients(recipe.ingredients) else Color.RED
