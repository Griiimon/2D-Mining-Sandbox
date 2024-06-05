extends CanvasLayer

@onready var sky: ColorRect = $Sky
@onready var stars: TextureRect = $Stars



func _process(_delta):
	var y: float= get_viewport().get_camera_2d().global_position.y
	var shader: ShaderMaterial= sky.material
	shader.set_shader_parameter("y", y)
	stars.modulate= lerp(Color.TRANSPARENT, Color.WHITE, clamp(pow(y / 5000.0, 2), 0.0, 1.0))
