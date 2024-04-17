class_name DebugComponent
extends Node

enum Type { DEFAULT, WARNING, ERROR, CRITICAL_ERROR }

@export var enabled: bool= false
@export var max_detail_level: int= 0
@export var prefix: String


func debug_message(text: String, detail_level: int, type: Type):
	if not enabled: return
	if detail_level > max_detail_level: return
	
	var final_text: String= (prefix +": " if prefix else "") + text

	print(final_text)
	
	match type:
		Type.WARNING:
			push_warning(final_text)
		Type.ERROR:
			push_error(final_text)
		Type.CRITICAL_ERROR:
			push_error(final_text)
			assert(false)
			
		
