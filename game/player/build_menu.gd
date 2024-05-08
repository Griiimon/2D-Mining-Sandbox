extends Control
class_name BuildMenu

signal select_buildable(buildable)


@export var build_list_item_scene: PackedScene

@onready var list = %"VBoxContainer Buildables"
@onready var ingredients_panel = %Ingredients
@onready var ingredients = %"VBox Ingredients"


var buildables: Array[Buildable]



func _ready():
	init()


func init():
	buildables.clear()
	
	for block in DataManager.blocks:
		if block is ArtificialBlock:
			buildables.append(Buildable.new(Buildable.Type.BLOCK, block))

	for entity in DataManager.block_entities:
		buildables.append(Buildable.new(Buildable.Type.ENTITY, entity))

	ingredients_panel.hide()


func build_list(player: BasePlayer):
	Utils.free_children(list)

	for buildable in buildables:
		var item: BuildListItem= build_list_item_scene.instantiate()
		list.add_child(item)
		item.init(buildable, Global.game.player)
		item.selected.connect(select_item.bind(item))
		item.mouse_entered.connect(hover_item.bind(item))


func set_ingredients(buildable: Buildable):
	Utils.free_children(ingredients)
	Utils.make_ingredient_list(ingredients, buildable.get_ingredients())
	ingredients_panel.show()


func select_item(item: BuildListItem):
	hide()
	select_buildable.emit(item.buildable)


func hover_item(item: BuildListItem):
	set_ingredients(item.buildable)
