extends BaseScenario

@export var item: Item
@export var item_count: int= 1

var objective_completed: bool= false


func _ready():
	description= "Collect %d %ss" % [ item_count, item.get_display_name() ]
	super()


func post_init():
	update_objectives(get_objective_text(0))


func on_player_spawned():
	player.inventory.update.connect(check_inventory)


func check_inventory():
	var items: int= player.inventory.get_item_count(item)
	update_objectives(get_objective_text(items))
	if items >= item_count:
		win()


func get_objective_text(ingots_in_inventory: int)-> String:
	return "%d / %d %s" % [ ingots_in_inventory, item_count, item.get_display_name() ]
