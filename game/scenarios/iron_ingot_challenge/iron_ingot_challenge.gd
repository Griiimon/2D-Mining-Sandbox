extends BaseScenario

@export var ingot_count: int= 1


func _ready():
	description= "Create %d iron ingots" % [ ingot_count ]
	super()


func post_init():
	update_objectives(get_objective_text(0))


func get_objective_text(ingots_in_inventory: int)-> String:
	return "%d / %d ingots" % [ ingots_in_inventory, ingot_count]
