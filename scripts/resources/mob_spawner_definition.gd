class_name MobSpawnerDefinition
extends Resource

enum Faction { FRIENDLY, NEUTRAL, HOSTILE }

@export var faction: Faction
@export var probability: float= 10.0
@export var require_air_radius: int= 3

