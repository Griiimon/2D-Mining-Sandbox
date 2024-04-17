class_name MobSpawnerDefinition
extends Resource

enum Faction { FRIENDLY, NEUTRAL, HOSTILE }

@export var faction: Faction
@export var probability: float= 10.0
@export var empty_radius: int= 3



func can_spawn(tile: Vector2i, world: World)-> bool:
	if not Utils.chance100(probability):
		return false
	
	if not world.is_air_at_rect(Rect2i(tile - Vector2i.ONE * empty_radius, Vector2i.ONE * (empty_radius * 2 + 1))):
		return false
	
	return true
	
	
	
