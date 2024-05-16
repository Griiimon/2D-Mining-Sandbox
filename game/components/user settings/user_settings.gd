extends Node

@export var settings: Array[String]
@export var controls: Array[Control]


func _ready():
	assert(len(settings) == len(controls))
	
	for i in settings.size():
		apply_setting(controls[i], settings[i])
		connect_control(controls[i], settings[i])


func apply_setting(control: Control, setting_key: String):
	var setting= UserConfig.get_setting(setting_key)

	control.set_block_signals(true)

	if control is CheckBox:
		assert(setting is bool)
		control.button_pressed= setting
	elif control is Slider:
		assert(setting is float or setting is int)
		control.value= setting
	elif control is LineEdit:
		assert(setting is String)
		control.text= setting

	control.set_block_signals(false)


func connect_control(control: Control, setting_key: String):
	if control is CheckBox:
		control.toggled.connect(UserConfig.update_setting.bind(setting_key))
	elif control is Slider:
		control.value_changed.connect(UserConfig.update_setting.bind(setting_key))
	elif control is LineEdit:
		control.text_changed.connect(UserConfig.update_setting.bind(setting_key))
