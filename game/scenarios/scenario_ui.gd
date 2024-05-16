extends CanvasLayer


@onready var description_container: Container = $"Description CenterContainer"
@onready var description_label: Label = %"Description Label"
@onready var description_timeout = %"Description Timeout"

@onready var time_and_objectives_container: Container = $"Time And Objectives MarginContainer"
@onready var time_label: Label = %"Time Label"
@onready var objectives_separator = %"Objectives HSeparator"
@onready var objectives_label: Label = %"Objectives Label"


var scenario: BaseScenario


func _ready():
	scenario= get_parent()
	await scenario.ready
	
	if scenario.description:
		description_label.text= scenario.description
		description_container.show()
		description_timeout.start()

	if scenario.has_timer:
		time_and_objectives_container.show()
		time_label.show()
		update_time()
	
	post_init()


func post_init():
	pass


func _process(_delta):
	update_time()


func update_time():
	time_label.text= Utils.get_time_string(scenario.get_time())


func update_objectives(text: String):
	time_and_objectives_container.show()
	if time_label.visible:
		objectives_separator.show()
	objectives_label.text= text
	objectives_label.show()


func _on_description_timeout_timeout():
	description_container.hide()
