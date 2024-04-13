class_name Utils



static func chancef(chance: float)-> bool:
	return randf() < chance


static func chance100(chance: float)-> bool:
	return chancef(chance / 100.0)


static func chance50()-> bool:
	return chance100(50)
