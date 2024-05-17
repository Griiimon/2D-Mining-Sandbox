extends BaseSoundPlayer


var stream_players: Array[AudioStreamPlayer]



func _ready():
	stream_players.assign(get_children())


func play(sound_key: String):
	var player: AudioStreamPlayer= get_free_player()
	if player:
		if not DataManager.sound_library.library.has(sound_key):
			push_error("No %s in sound library" % [sound_key])
			return
			
		var sound: AudioStream= DataManager.sound_library.library[sound_key]
		
		player.stream= sound
		player.play()


func get_free_player()-> AudioStreamPlayer:
	for player: AudioStreamPlayer in stream_players:
		if not player.playing:
			return player
	return null
