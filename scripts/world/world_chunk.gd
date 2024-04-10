class_name WorldChunk
extends TileMap

const SIZE= 32

@export var coords: Vector2i
@export var auto_generate_tiles: bool= true

var world: World



func _ready():
	world= get_parent().get_parent()

	tile_set= DataManager.tile_set
	
	if auto_generate_tiles:
		generate_tiles()

	#world.register_chunk(self)


func generate_tiles():
	pass


func _tile_data_runtime_update(layer, coords, tile_data):
	pass


func _use_tile_data_runtime_update(layer, coords):
	return Engine.is_editor_hint()


func get_block_id(tile_pos: Vector2i)-> int:
	tile_pos= make_tile_pos_local(tile_pos)
	if not tile_pos in get_used_cells(0):
		return -1
	return get_cell_source_id(0, tile_pos)


func make_tile_pos_local(tile_pos: Vector2i)-> Vector2i:
	return tile_pos 


func break_block(tile_pos: Vector2i):
	var block_id: int= get_block_id(tile_pos)
	if block_id >= 0:
		var block: Block= DataManager.blocks[block_id]
		var world_pos: Vector2= map_to_local(tile_pos)
		if block.drop:
			world.spawn_item(block.drop, world_pos)
		set_cell(0, tile_pos, -1)

		Effects.spawn_particle_system(world_pos, MyParticleSystem.ParticleSettings.new(20, 3, block.particle_color, 1, 1, 2, true, 50, 100, 500, Vector2.UP, 90, true, 0.5, 0))
