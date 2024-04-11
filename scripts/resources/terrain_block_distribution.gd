class_name TerrainBlockDistribution
extends Resource

@export var blocks: Array[Block]
@export var noise: FastNoiseLite
@export var noise_threshold: float

var processed_noises: Array[FastNoiseLite]


func initialize():
	var seed: int= Global.game.settings.seed
	
	if noise:
		for i in blocks.size():
			var new_noise: FastNoiseLite= noise.duplicate(true)
			new_noise.seed= seed
			processed_noises.append(new_noise)
			seed= wrapi(seed + 100, 0, 1_000_000)
		

func get_block(pos: Vector2i)-> Block:
	if not noise:
		return blocks[0]
	for i in len(blocks):
		if processed_noises[i].get_noise_2dv(pos) > noise_threshold:
			return blocks[i]
	return null
