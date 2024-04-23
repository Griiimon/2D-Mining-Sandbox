class_name World
extends Node2D

signal initialization_finished

const ENTITY_TICKS= 60
const BLOCK_TICKS= 5

const TILE_SIZE= 32

@export var world_item_scene: PackedScene
@export var world_chunk_scene: PackedScene
@export var chunks: Node2D
@export var generator: TerrainGenerator
@export var explosion_particles: ParticleSettings

@onready var chunk_updater: ChunkUpdater = $"Chunk Updater"
@onready var mob_spawner: MobSpawner = $"Mob Spawner"
@onready var mobs = $Mobs
@onready var block_entities = $"Block Entities"


var tick_entities: Array[BaseBlockEntity]

var neighbor_updates: Array[Vector2i]

var chunk_storage:= {}



func _ready():
	if generator:
		generator.initialize()


func start():
	chunk_updater.start()
	mob_spawner.start()
	initialization_finished.emit()


func _physics_process(_delta):
	if Engine.is_editor_hint(): return
	
	if Engine.get_physics_frames() % int(60.0 / ENTITY_TICKS) == 0:
		for entity in tick_entities:
			entity.tick(self)

	if Engine.get_physics_frames() % int(60.0 / BLOCK_TICKS) == 0:
		for chunk in get_chunks():
			chunk.tick_blocks()

	execute_neighbor_updates()


func get_block(tile_pos: Vector2i)-> Block:
	var block_id: int= get_block_id(tile_pos)
	if block_id == -1:
		return null
	return DataManager.blocks[block_id]


func get_block_id(tile_pos: Vector2i)-> int:
	var chunk: WorldChunk= get_chunk_at(tile_pos)
	if not chunk: 
		NodeDebugger.msg(self, "get_block_id() null chunk", DebugComponent.Type.WARNING)
		return -1
	return chunk.get_block_id(tile_pos)


func get_block_id_at(pos: Vector2)-> int:
	return get_block_id(get_tile(pos))


func schedule_block(tile_pos: Vector2i):
	get_chunk_at(tile_pos).schedule_block(tile_pos)


func unschedule_block(tile_pos: Vector2i):
	get_chunk_at(tile_pos).unschedule_block(tile_pos)


func trigger_neighbor_update(origin_pos: Vector2i):
	if origin_pos in neighbor_updates: return
	NodeDebugger.msg(self, str("trigger neighbor update ", origin_pos), 2)
	neighbor_updates.append(origin_pos)


func execute_neighbor_updates():
	for origin_pos in neighbor_updates:
		for x in [-1, 0, 1]:
			for y in [-1, 0, 1]:
				if x != 0 or y != 0:
					var pos: Vector2i= origin_pos + Vector2i(x, y)
					var block: Block= get_block(pos)
					if block:
						NodeDebugger.msg(self, str("block neighbor update at ", pos, " origin ", origin_pos), 3)
						block.on_neighbor_update(self, pos, origin_pos)

	neighbor_updates.clear()


func get_tile(pos: Vector2)-> Vector2i:
	var chunk: WorldChunk= get_chunk_at((pos / WorldChunk.SIZE).floor())
	if not chunk: 
		assert(false)
		return Vector2i.ZERO
	DebugHud.send("get_tile() chunk", str(chunk.coords))
	return chunk.local_to_map(pos)


func get_chunk_coords_at(tile_pos: Vector2i)-> Vector2i:
	return (Vector2(tile_pos) / WorldChunk.SIZE).floor()


func get_chunk_at(tile_pos: Vector2i)-> WorldChunk:
	return get_chunk(get_chunk_coords_at(tile_pos))


func get_chunk(chunk_coords: Vector2i)-> WorldChunk:
	var key: String= str(chunk_coords)
	var node: Node= chunks.get_node_or_null(key)
	return node
	

func get_chunks()-> Array[WorldChunk]:
	var result: Array[WorldChunk]= []
	result.assign(chunks.get_children())
	return result


func create_chunk(chunk_coords: Vector2i, storage: ChunkStorage= null):
	var chunk: WorldChunk= world_chunk_scene.instantiate()
	chunk.name= str(chunk_coords)
	chunk.position= chunk_coords * WorldChunk.SIZE * TILE_SIZE
	chunks.add_child(chunk)
	chunk.coords= chunk_coords
	if storage:
		chunk.restore(storage)
	else:
		chunk.generate_tiles()


func get_chunk_storage(chunk_coords: Vector2i)-> ChunkStorage:
	var key: String= str(chunk_coords)
	if not chunk_storage.has(key):
		return null
	return chunk_storage[key]


func map_to_local(tile_pos: Vector2i)-> Vector2:
	return tile_pos * TILE_SIZE + Vector2i.ONE * TILE_SIZE / 2


func get_block_hardness(tile_pos: Vector2i)-> float:
	var block: Block= get_block(tile_pos)
	if not block:
		return 0.0
	return block.hardness


func set_block(tile_pos: Vector2i, block: Block, neighbor_update: bool= true):
	var chunk: WorldChunk= get_chunk_at(tile_pos)
	if chunk:
		chunk.set_block(chunk.get_local_pos(tile_pos), block, neighbor_update)


func delete_block(tile_pos: Vector2i, neighbor_update: bool= true):
	var chunk: WorldChunk= get_chunk_at(tile_pos)
	if not chunk: 
		assert(false)
		return null
	chunk.delete_block(tile_pos, neighbor_update)


func break_block(tile_pos: Vector2i, with_drops: bool= true):
	var chunk: WorldChunk= get_chunk_at(tile_pos)
	if not chunk: 
		assert(false)
		return null
	chunk.break_block(tile_pos, with_drops)
	

func spawn_item(item: Item, pos: Vector2)-> WorldItem:
	var world_item: WorldItem= world_item_scene.instantiate()
	world_item.position= pos
	add_child(world_item)
	world_item.item= item

	world_item.register(self)

	return world_item


func throw_item(item: Item, pos: Vector2, velocity: Vector2):
	spawn_item(item, pos).velocity= velocity


func register_item(item: WorldItem)-> WorldChunk:
	var chunk: WorldChunk= get_chunk_at(get_tile(item.global_position))
	assert(chunk)
	if not item in chunk.items:
		chunk.items.append(item)
	return chunk


func unregister_item(item: WorldItem, chunk: WorldChunk):
	chunk.items.erase(item)


func spawn_block_entity(tile_pos: Vector2i, entity_scene: PackedScene):
	var entity: BaseBlockEntity= entity_scene.instantiate()
	entity.position= tile_pos * TILE_SIZE
	block_entities.add_child(entity)
	
	if entity.register_tick:
		tick_entities.append(entity)


func unregister_block_entity(entity: BaseBlockEntity):
	tick_entities.erase(entity)


func spawn_mob(mob_def: MobDefinition, tile: Vector2i):
	var mob= mob_def.scene.instantiate()
	mob.position= map_to_local(tile)
	mobs.add_child(mob)


func remove_mobs_in_rect(rect: Rect2):
	for mob in mobs.get_children():
		if rect.has_point(mob.global_position):
			mob.queue_free()


func explosion(center: Vector2i, damage: float, radius: float, block_dmg_factor: float= 1):
	for x in range(-radius, radius):
		for y in range(-radius, radius):
			var tile: Vector2i= center + Vector2i(x, y)
			if (tile - center).length() <= radius:
				var block: Block= get_block(tile)
				if block and damage * block_dmg_factor > block.hardness:
					delete_block(tile)
	
	var query:= PhysicsShapeQueryParameters2D.new()
	query.transform.origin= map_to_local(center)
	var circle:= CircleShape2D.new()
	circle.radius= radius * TILE_SIZE
	query.shape= circle
	query.collide_with_areas= true
	query.collision_mask= Utils.build_mask([Global.SOLID_ENTITY_COLLISION_LAYER, Global.HURTBOX_COLLISION_LAYER])
	
	var result: Array[Dictionary]= get_world_2d().direct_space_state.intersect_shape(query)
	
	var dmg:= Damage.new(damage, Damage.Type.EXPLOSION)
	for intersect in result:
		if intersect.is_empty(): continue
		
		var health: HealthComponent= Utils.get_health(intersect.collider)
		if health:
			health.receive_damage(dmg)
			NodeDebugger.msg(self, "deal explosion damage to " + intersect.collider.name, 2)
	Effects.spawn_particle_system(map_to_local(center), explosion_particles)


func _on_chunk_updater_initial_run_completed():
	var settings: GameSettings= Global.game.settings
	for x in range(-settings.spawn_clearing_radius, settings.spawn_clearing_radius):
		for y in range(-settings.spawn_clearing_radius, settings.spawn_clearing_radius):
			delete_block(settings.player_spawn + Vector2i(x, y), false)

	start()


func is_air_at(tile_pos: Vector2i)-> bool:
	return get_block(tile_pos) == null


func is_air_at_rect(rect: Rect2i):
	for x in rect.size.x:
		for y in rect.size.y:
			var tile: Vector2i= rect.position + Vector2i(x, y)
			if not is_air_at(tile):
				return false
	return true
