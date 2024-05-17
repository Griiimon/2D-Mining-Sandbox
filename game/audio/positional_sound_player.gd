extends BaseSoundPlayer


var stream_players: Array[AudioStreamPlayer2D]



func _ready():
	stream_players.assign(get_children())


func play(sound_key: String, position: Vector2):
	if not DataManager.sound_library.library.has(sound_key):
		push_error("No %s in sound library" % [sound_key])
		return
		
	play_sound(DataManager.sound_library.library[sound_key], position)


func play_sound(sound: AudioStream, position):
	var player: AudioStreamPlayer2D= get_free_player()
	if player:
		player.stream= sound
		player.position= position
		player.play()


func play_material_sound(mat_type1: MaterialSoundLibrary.Type, mat_type2: MaterialSoundLibrary.Type, position: Vector2):
	var key: String= MaterialSoundLibrary.get_key(mat_type1, mat_type2)
	if not DataManager.material_sound_library.sounds.has(key):
		var type_keys: Array= MaterialSoundLibrary.Type.keys()
		push_error("No %s vs %s in material sound library" % [ type_keys[mat_type1], type_keys[mat_type2] ])
		return
		
	play_sound(DataManager.material_sound_library.sounds[key].pick_random(), position)


func get_free_player()-> AudioStreamPlayer2D:
	for player: AudioStreamPlayer2D in stream_players:
		if not player.playing:
			return player
	return null
