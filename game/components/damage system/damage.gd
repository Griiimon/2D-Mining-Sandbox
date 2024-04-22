extends Resource
class_name Damage

enum Type { MELEE, EXPLOSION, ENVIRONMENT, FALL }


@export var type: Type
@export var value: float


func _init(_value: float= 0, _type: Type= Type.MELEE):
	type= _type
	value= _value
