@tool
extends EditorPlugin

var matrix_view: Control


func _enter_tree() -> void:
	matrix_view = load(get_script().resource_path.get_base_dir() + "/matrix_view.tscn").instantiate()

	get_editor_interface().get_editor_main_screen().add_child(matrix_view)
	_make_visible(false)


func _exit_tree():
	if matrix_view:
		matrix_view.queue_free()


func _has_main_screen():
	return true


func _make_visible(visible):
	if matrix_view:
		matrix_view.visible = visible


func _get_plugin_name():
	return "Sound Material Matrix"


func _get_plugin_icon():
	# Must return some kind of Texture for the icon.
	return EditorInterface.get_editor_theme().get_icon("Node", "EditorIcons")
