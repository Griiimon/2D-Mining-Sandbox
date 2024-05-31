class_name MobSpawnerDefinition
extends Resource

enum Faction { FRIENDLY, NEUTRAL, HOSTILE }

@export var faction: Faction
@export var probability: float= 10.0
@export var empty_radius: int= 3
@export var min_distance_to_same: int= 20
@export var min_distance_to_other: int= 10
@export var only_underground: bool= false
@export var only_overworld: bool= false
@export var only_in_fluid: bool= false



func can_spawn(tile: Vector2i, world: World)-> bool:
	if not Utils.chance100(probability):
		return false
	
	var underground= world.has_block_above(tile)
	
	if only_underground and not underground:
		return false
	
	if only_overworld and underground:
		return false
	
	var empty_rect:= Rect2i(tile - Vector2i.ONE * empty_radius, Vector2i.ONE * (empty_radius * 2 + 1))

	if only_in_fluid:
		return world.is_fluid_at_rect(empty_rect)
	
	if not world.is_air_at_rect(empty_rect):
		return false
	
	return true
