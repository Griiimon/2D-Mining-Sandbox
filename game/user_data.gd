class_name UserData
extends Resource


var volume: int= 50:
	set(value):
		volume= value
		AudioServer.set_bus_volume_db(0, linear_to_db(volume / 100.0))
var fullscreen: bool= false:
	set(value):
		fullscreen= value
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if fullscreen else DisplayServer.WINDOW_MODE_WINDOWED)

