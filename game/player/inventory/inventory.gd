class_name Inventory

const SIZE= 33		# include 9 for hotbar


var items: Array[InventoryItem]

var update_callback: Callable

var block_update_callback: bool= false


func _init():
	for i in SIZE:
		items.append(InventoryItem.new())


func add_item(inv_item: InventoryItem, amount: int= 1, do_update: bool= true):
	inv_item.amount+= amount
	if do_update:
		updated()


func sub_item(inv_item: InventoryItem, amount: int= 1, do_update: bool= true):
	assert(inv_item.amount >= amount)
	inv_item.amount-= amount

	if do_update:
		updated()


func sub(item_type: Item, amount: int= 1, do_update: bool= true):
	var total: int= amount
	for inv_item in items:
		if inv_item.item == item_type:
			var before: int= inv_item.amount
			inv_item.amount= max(inv_item.amount - total, 0)
			total-= before - inv_item.amount
			
			if total == 0:
				if do_update:
					updated()
				return
	
	assert(false, "trying to substract non-existing item/too many items")


func add_new_item(item: Item, amount: int= 1):
	if item.can_stack:
		for it in items:
			if it.item == item:
				it.amount+= amount
				updated()
				return
	
	var slot_idx: int= find_empty_slot()
	
	if slot_idx >= 0:
		items[slot_idx].item= item
		items[slot_idx].amount= amount
		updated()
		return
	
	assert(false, "trying to add item to full inventory")


func add_item_to_slot(slot_idx: int, item: Item, amount: int= 1):
	assert(not items[slot_idx].item or item == items[slot_idx].item)
	items[slot_idx].item= item
	items[slot_idx].amount+= amount
	updated()


func sub_ingredients(ingredients: Array[InventoryItem]):
	for ingredient in ingredients:
		sub(ingredient.item, ingredient.amount, false)
	updated()


func has_ingredients(ingredients: Array[InventoryItem])-> bool:
	for ingredient in ingredients:
		if not has(ingredient.item, ingredient.amount):
			return false
	return true


func has(item_type: Item, amount: int= 0)-> bool:
	var total: int= amount
	for inv_item in items:
		if inv_item.item == item_type:
			if inv_item.amount >= total:
				return true
				
			total-= inv_item.amount
			
	return false


func find_empty_slot()-> int:
	for i in SIZE:
		if not items[i].item:
			return i
	return -1


func clear_slot(idx: int):
	clear_item(items[idx])


func clear_item(inv_item: InventoryItem):
	inv_item.item= null
	inv_item.amount= 0
	updated()


func updated():
	if update_callback and not block_update_callback:
		update_callback.call()
