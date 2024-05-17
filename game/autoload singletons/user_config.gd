extends Node

const FILE_PATH: String= "user://user_config.cfg" 


var config_file:= ConfigFile.new()


var default_settings: String="""
	[Settings]
	volume=50
	fullscreen=false
	world_seed=""
"""


func _init():
	if not FileAccess.file_exists(FILE_PATH):
		config_file.parse(default_settings)
		save_data()
	
	load_data()


func save_data():
	config_file.save(FILE_PATH)


func load_data():
	config_file.load(FILE_PATH)
	for section in config_file.get_sections():
		for key in config_file.get_section_keys(section):
			on_update_setting(config_file.get_value(section, key), key, section)


func get_setting(key: String, section: String= "Settings"):
	assert(config_file.has_section(section))
	assert(config_file.has_section_key(section, key))
	return config_file.get_value(section, key)


func update_setting(value: Variant, key: String, section: String= "Settings"):
	assert(config_file.has_section(section))
	assert(config_file.has_section_key(section, key))
	config_file.set_value(section, key, value)
	save_data()
	on_update_setting(value, key, section)
	

func on_update_setting(value: Variant, key: String, section: String):
	if section == "Settings":
		match key:
			"volume":
				AudioServer.set_bus_volume_db(0, linear_to_db(value / 100.0))
			"fullscreen":
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if value else DisplayServer.WINDOW_MODE_WINDOWED)
