extends Resource
class_name CraftingRecipe


@export var product: Item
@export var product_count: int= 1
@export var ingredients: Array[InventoryItem]
@export var crafting_duration: float= 1
