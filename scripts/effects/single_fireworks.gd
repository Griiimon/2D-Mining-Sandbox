extends CPUParticles2D
class_name SingleFireworks


const COLORS= [ Color.RED, Color.YELLOW, Color.SKY_BLUE, Color.GREEN, Color.WHITE ]

func _ready():
	color= COLORS.pick_random()
	emitting= true

func _on_timer_timeout():
	queue_free()
