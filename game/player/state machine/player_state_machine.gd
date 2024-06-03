extends FiniteStateMachine
class_name PlayerStateMachine

@onready var player: BasePlayer= get_parent()
@onready var default_state: PlayerState = $"Default"
@onready var mining_state: PlayerMiningState = $"Mining"
@onready var item_using_state: PlayerState = $"Item Using"
@onready var item_charging_state: PlayerState = $"Item Charging"
@onready var dying_state: PlayerState = $"Dying"
@onready var building_state: PlayerBuildingState = $Building
@onready var fishing_state: PlayerFishingState = $Fishing



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


func _on_place_block(block: Block, block_state: Block.State, tile_pos: Vector2i, ingredients: Array[InventoryItem]):
	player.get_world().set_block(block, tile_pos, block_state)
	player.inventory.sub_ingredients(ingredients)


func _on_building_build_entity(block_entity_definition: BlockEntityDefinition, tile_pos: Vector2i, ingredients: Array[InventoryItem]):
	player.get_world().spawn_block_entity(block_entity_definition, tile_pos)
	player.inventory.sub_ingredients(ingredients)


func _on_building_cancel():
	change_state(default_state)


func _on_player_ui_select_buildable(buildable: Buildable):
	change_state(building_state)
	building_state.init(buildable)


func _on_exit_vehicle():
	change_state(default_state)


func release_charge(charge_primary: bool, total_charge: float):
	player.release_charge(charge_primary, total_charge)
