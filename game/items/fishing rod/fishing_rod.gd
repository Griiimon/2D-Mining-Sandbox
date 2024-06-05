class_name FishingRod
extends HandItemObject

@export var reel_in_speed: float= 500.0

@onready var line: Line2D = $Line
@onready var hook: Line2D = $Hook
@onready var hook_body: FishingRodHookBody = %"Hook body"
@onready var hook_orig_position = $"Hook Orig Position"

var line_orig_position: Node2D

var hook_tween: Tween
var reel_in: bool= false
var previous_line_pos: Vector2



func _ready():
	line_orig_position= Node2D.new()
	line_orig_position.position= line.global_position
	add_child(line_orig_position)
	line_orig_position.global_position= line.global_position
	line.top_level= true
	await get_tree().process_frame
	line.show()


func on_equip():
	super()
	get_player().state_machine.change_state(get_player().state_machine.fishing_state)


func on_unequip():
	get_player().state_machine.change_state(get_player().state_machine.default_state)


func action(primary: bool):
	if not primary:
		reel_in= true
		#hook.top_level= true
		previous_line_pos= line.global_position
		hook_body.reel_in()


func release_charge(total_charge: float, primary: bool):
	if not primary: return
	hook_body.shoot(hook_orig_position.global_position, total_charge, (global_transform.x - global_transform.y).normalized())


func _process(delta):
	line.global_position= line_orig_position.global_position
	line.points[-1]= line.to_local(hook.global_position)

	if not hook_body.top_level: 
		hook.global_position= hook_orig_position.global_position
		return

	if reel_in:
		hook_body.position= hook_body.position.move_toward(hook_orig_position.global_position, reel_in_speed * delta)
		if hook_body.position.distance_to(hook_orig_position.global_position) < 1:
			reel_in= false
			hook_body.top_level= false
			hook_body.position= Vector2.ZERO
	
	hook.global_position= lerp(hook.global_position, hook_body.global_position, delta * 10)


func _physics_process(_delta):
	if not reel_in: return
	
	if hook_body.global_position.distance_squared_to(line.global_position) >\
		hook_body.global_position.distance_squared_to(previous_line_pos):
			hook_body.global_position+= line.global_position - previous_line_pos
	previous_line_pos= line.global_position
