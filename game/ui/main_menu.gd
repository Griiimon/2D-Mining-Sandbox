extends CanvasLayer


func _ready():
	get_tree().paused= false


func _on_close_button_pressed():
	get_tree().quit()
