class_name BaseBlockEntity
extends StaticBody2D

# size in tiles
@export var size: Vector2i= Vector2i.ONE
@export var has_collision: bool= false

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D


func _ready():
	collision_shape.shape.size= size * World.TILE_SIZE
	collision_shape.position= size * World.TILE_SIZE / 2
	
	collision_shape.disabled= not has_collision