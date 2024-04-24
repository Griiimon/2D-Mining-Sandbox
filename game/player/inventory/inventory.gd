class_name Inventory

const SIZE= 33		# include 9 for hotbar


var items: Array[InventoryItem]

var update_callback: Callable

func _init():
	for i in SIZE:
		items.append(InventoryItem.new())


func add_item(inv_item: InventoryItem, amount: int= 1):
	inv_item.amount+= amount
	updated()


func sub_item(inv_item: InventoryItem, amount: int= 1):
	assert(inv_item.amount >= amount)
	inv_item.amount-= amount
	if inv_item.amount == 0:
		inv_item.item= null
	updated()


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


func find_empty_slot()-> int:
	for i in SIZE:
		if not items[i].item:
			return i
	return -1


func clear_slot(idx: int):
	items[idx].item= null
	items[idx].amount= 0
	updated()


func updated():
	if update_callback:
		update_callback.call()
