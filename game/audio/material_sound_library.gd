class_name MaterialSoundLibrary
extends Resource

enum Type { ROCK, METAL, THIN_METAL, LEATHER, PLASTIC, WOOD }


@export var sound_paths: Dictionary

var sounds: Dictionary


func get_key(type1: Type, type2: Type)-> String:
	return str(int(type1), ",", int(type2))


func build():
	for key in sound_paths.keys():
		var arr= sound_paths[key]
		if arr:
			sounds[key]= []
			for sound_file in arr:
				assert(FileAccess.file_exists(sound_file))
				sounds[key].append(load(sound_file))
