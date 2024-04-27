class_name InventoryItem
extends Resource

@export var item: Item
@export var count: int= 1:
	set(n):
		count= n
		if n == 0:
			item= null
