extends PlayerState

signal release_charge(primary, total_charge)

var total_charge: float


func on_enter():
	total_charge= 0


func on_physics_process(delta: float):
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and not Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		release_charge.emit(charge_primary, total_charge)
		return
		
	total_charge+= delta
