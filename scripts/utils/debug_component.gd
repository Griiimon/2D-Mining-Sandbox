class_name DebugComponent
extends Node

enum Type { DEFAULT, WARNING, ERROR, CRITICAL_ERROR }

@export var enabled: bool= false
@export var max_detail_level: int= 0
@export var prefix: String

func debug_message(text: String, detail_level: int, type: Type):
	if not enabled: return
	
	print((prefix +": " if prefix else "") + text)
