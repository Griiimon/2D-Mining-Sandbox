@tool
class_name Cloud
extends Node2D

const directions= [ Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN ]

@export var generate_dynamic: bool= false
@export var grid_size: int= 16

@onready var polygon: Polygon2D = $"Dynamic Polygon"
@onready var premade = $Premade


var points: Array[Vector2i]= []
var pos: Vector2i
var velocity: Vector2


func _ready():
	if not generate_dynamic:
		polygon.hide()
		var rand_polygon: Polygon2D= premade.get_children().pick_random()
		rand_polygon.color.a= 0.5
		rand_polygon.show()
		return
	else:
		polygon.show()
		polygon.color.a= 0.5

	generate_polygon()


func _physics_process(delta):
	position+= velocity * delta


func generate_polygon():
	var i:= 0
	while true:
		var new_pos: Vector2i= pos + get_rand_direction()
		while points.has(new_pos) or (new_pos == Vector2i.ZERO and len(points) < 8):
			new_pos= pos + get_rand_direction()
		pos= new_pos
		points.append(pos)
		print(pos)
		
		if pos == Vector2i.ZERO:
			break
		i+= 1
		if i > 100:
			return

	for point in points:
		polygon.polygon.append(point * grid_size)	


func get_rand_direction()-> Vector2i:
	var result: Vector2i= directions.pick_random()
	if len(points) < 10 and result.x == -1:
		print("retry")
		return get_rand_direction()
		
	if Utils.chance100(min(90, len(points))) and (pos.length() < (pos + result).length()):
		print("retry")
		return get_rand_direction()
		
	return result
