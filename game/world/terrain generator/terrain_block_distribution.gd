class_name TerrainBlockDistribution
extends Resource

@export var blocks: Array[Block]
@export var noise: FastNoiseLite
@export var noise_threshold: float

var processed_noises: Array[FastNoiseLite]


func initialize():
	var current_seed: int
	if GameManager.world_seed:
		current_seed= hash(GameManager.world_seed)
	else:
		current_seed= Global.game.settings.world_seed
	
	if noise:
		for i in blocks.size():
			var new_noise: FastNoiseLite= noise.duplicate(true)
			new_noise.seed= current_seed
			processed_noises.append(new_noise)
			current_seed= wrapi(current_seed + 100, 0, 1_000_000)
		

func get_block(pos: Vector2i)-> Block:
	if not noise:
		return blocks[0]
	for i in len(blocks):
		if processed_noises[i].get_noise_2dv(pos) > noise_threshold:
			return blocks[i]
	return null
