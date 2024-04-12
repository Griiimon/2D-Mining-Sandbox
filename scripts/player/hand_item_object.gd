class_name HandItemObject
extends Node2D

const START_ATTACK_ANIMATION_ACTION= "start_attack"
const END_ATTACK_ANIMATION_ACTION= "end_attack"

@export var action_player: AnimationPlayer
var type: HandItem


func set_attack_state(b: bool):
	if action_player:
		if b:
			if action_player.has_animation(START_ATTACK_ANIMATION_ACTION):
				action_player.play(START_ATTACK_ANIMATION_ACTION)
			elif action_player.has_animation(END_ATTACK_ANIMATION_ACTION):
				action_player.play(END_ATTACK_ANIMATION_ACTION)


func can_mine()-> bool:
	return type.can_mine()
