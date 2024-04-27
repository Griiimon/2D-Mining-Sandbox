extends FiniteStateMachine
class_name PlayerStateMachine


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
