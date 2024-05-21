class_name PlayerEffect


enum Type { MOVE_SPEED, JUMP_FORCE, MINING_SPEED, MELEE_DAMAGE }

var type: Type
var multiplier: float
var duration: int


func _init(_type: Type, _multiplier: float, _duration: int):
	type= _type
	multiplier= _multiplier
	duration= _duration


func tick()-> bool:
	duration-= 1
	if duration == 0:
		return false
	return true
