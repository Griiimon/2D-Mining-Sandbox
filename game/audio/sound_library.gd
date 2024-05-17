class_name SoundLibrary
extends Resource


@export var items: Array[SoundLibraryItem]

var library: Dictionary



func build():
	for item in items:
		library[item.key]= item.sound
