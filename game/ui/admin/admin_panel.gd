extends CanvasLayer

@onready var state_machine: FiniteStateMachine = $"State Machine"


func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("toggle_admin"):
			visible= not visible
			if Global.game and Global.game.player:
				Global.game.player.freeze= visible
			if not visible:
				state_machine.cancel_state()
				
