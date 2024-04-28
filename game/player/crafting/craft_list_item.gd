extends PanelContainer
class_name CraftingListItem

signal selected

@onready var label = $MarginContainer/Label

var recipe: CraftingRecipe
var available: bool= false


func init(_recipe: CraftingRecipe, player: BasePlayer):
	recipe= _recipe
	label.text= recipe.product.get_display_name()
	update(player)
	deselect()


func _on_gui_input(event):
	if not available: return
	
	if event is InputEventMouseButton:
		if event.pressed:
			select()


func select():
	modulate= Color.WHITE
	selected.emit()


func deselect():
	modulate= Color.WEB_GRAY


func update(player: BasePlayer):
	available= player.inventory.has_ingredients(recipe.ingredients)
	label.modulate= Color.WHITE if available else Color.RED
