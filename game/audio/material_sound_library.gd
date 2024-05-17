class_name MaterialSoundLibrary
extends Resource

enum Type { ROCK, METAL, THIN_METAL, PLASTIC, WOOD, FLESH, DIRT }


@export var sound_paths: Dictionary

var sounds: Dictionary


static func get_key(type1: Type, type2: Type)-> String:
	if type2 < type1:
		var tmp= type1
		type1= type2
		type2= tmp

	return str(int(type1), ",", int(type2))


func build():
	for key in sound_paths.keys():
		var arr= sound_paths[key].split("\n")
		if arr:
			sounds[key]= []
			for sound_file: String in arr:
				sound_file= sound_file.strip_escapes()
				assert(FileAccess.file_exists(sound_file), "Sound file %s doesnt exist" % [sound_file])
				sounds[key].append(load(sound_file))

