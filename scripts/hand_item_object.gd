class_name HandItemObject
extends Node2D


var type: HandItem


func can_mine()-> bool:
	return type.can_mine()
