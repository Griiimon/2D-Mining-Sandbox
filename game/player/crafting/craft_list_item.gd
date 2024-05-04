extends UIListItem
class_name CraftingListItem

var recipe: CraftingRecipe



func init(_recipe: CraftingRecipe, player: BasePlayer):
	recipe= _recipe
	label.text= recipe.product.get_display_name()
	update(player)
	deselect()


func update(player: BasePlayer):
	available= player.inventory.has_ingredients(recipe.ingredients)
	super(player)
