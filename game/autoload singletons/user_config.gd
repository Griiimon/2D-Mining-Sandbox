extends Node

const FILE_PATH: String= "user://user_UserData.tres" 


var settings: UserData



func _init():
	if not FileAccess.file_exists(FILE_PATH):
		settings= UserData.new()
		save_UserData()
	else:
		load_UserData()


func save_UserData():
	ResourceSaver.save(UserData, FILE_PATH)


func load_UserData():
	settings= load(FILE_PATH)


func get_setting(key: String):
	assert(key in settings)
	return settings.get(key)


func update_setting(value: Variant, key: String):
	assert(key in settings)
	settings.set(key, value)

