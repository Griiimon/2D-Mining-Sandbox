extends HandItemObject

@export var reel_in_speed: float= 500.0

@onready var line: Line2D = $Line
@onready var hook: Line2D = $Hook
@onready var hook_body: FishingRodHookBody = %"Hook body"
@onready var hook_orig_position = $"Hook Orig Position"


var hook_tween: Tween
var reel_in: bool= false




func on_equip():
	get_player().state_machine.change_state(get_player().state_machine.fishing_state)


func on_unequip():
	get_player().state_machine.change_state(get_player().state_machine.default_state)


func action(primary: bool):
	if not primary:
		reel_in= true


func release_charge(total_charge: float, primary: bool):
	if not primary: return
	
	hook_body.shoot(hook_orig_position.global_position, total_charge, (transform.x - transform.y).normalized())


func _process(delta):
	if not hook_body.top_level: return

	if reel_in:
		hook_body.position= hook_body.position.move_toward(hook_orig_position.global_position, reel_in_speed * delta)
		if hook_body.position.distance_to(hook_orig_position.global_position) < 1:
			reel_in= false
			hook_body.top_level= false
			hook_body.position= Vector2.ZERO
	
	hook.global_position= hook_body.global_position
	line.points[-1]= line.to_local(hook.global_position)
