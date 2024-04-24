extends Node
class_name BasePlayerCrafting

signal product_finished(product, count)


class QueueItem:
	var recipe: CraftingRecipe
	var count: int

	func _init(_recipe: CraftingRecipe, _count: int):
		recipe= _recipe
		count= _count


@export var player: BasePlayer


var queue: Array[QueueItem]

var progress: float


func _physics_process(delta):
	if queue.is_empty(): return
	
	progress+= delta
	
	var item: QueueItem= queue[0]
	if progress >= item.recipe.crafting_duration:
		progress= 0
		item.count-= 1
		product_finished.emit(item.recipe.product, item.recipe.product_count)
		
		if item.count == 0:
			queue.pop_front()


func add(recipe: CraftingRecipe, count: int= 1):
	if not queue.is_empty():
		var last_item: QueueItem= queue[-1]
		if last_item.recipe == recipe:
			last_item.count+= count
	else:
		progress= 0

	queue.append(QueueItem.new(recipe, count))
