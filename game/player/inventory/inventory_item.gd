class_name InventoryItem
extends Resource

@export var item: Item
@export var amount: int= 1:
	set(n):
		amount= n
		if n == 0:
			item= null
