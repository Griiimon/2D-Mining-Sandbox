extends HandItemObject

@onready var line: Line2D = $Line
@onready var hook: Line2D = $Hook
@onready var hook_body: FishingRodHookBody = %"Hook body"



func release_charge(total_charge: float, primary: bool):
	if not primary: return
	
	hook_body.shoot(total_charge, transform.x)


func _process(delta):
	if not hook_body.top_level: return
	
	hook.global_position= hook_body.global_position
	#line.points[-1]= hook.global_position - line.global_position
	line.points[-1]= line.to_local(hook.global_position)
