extends FiniteStateMachine
class_name PlayerStateMachine

@onready var player: BasePlayer= get_parent()
@onready var default_state: PlayerState = $"Default"
@onready var mining_state: PlayerState = $"Mining"
@onready var item_using_state: PlayerState = $"Item Using"
@onready var item_charging_state: PlayerState = $"Item Charging"
@onready var dying_state: PlayerState = $"Dying"



func _on_charge_item():
	change_state(item_charging_state)


func _on_start_mining():
	change_state(mining_state)


func _on_use_item():
	change_state(item_using_state)


func _on_stop_mining():
	change_state(default_state)


func _on_stop_using_item():
	change_state(default_state)


func _on_place_block(block, block_state, tile_pos):
	player.get_world().set_block(block, tile_pos, block_state)


func _on_building_build_entity(scene, tile_pos):
	player.get_world().spawn_block_entity(scene, tile_pos)


func _on_building_cancel():
	change_state(default_state)
