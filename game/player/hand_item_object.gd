class_name HandItemObject
extends Node2D

const START_ATTACK_ANIMATION_ACTION= "start_attack"
const END_ATTACK_ANIMATION_ACTION= "end_attack"

@export var action_player: AnimationPlayer
var type: HandItem


func set_attack_state(b: bool):
	assert(action_player)
	if b:
		if action_player.has_animation(START_ATTACK_ANIMATION_ACTION):
			action_player.play(START_ATTACK_ANIMATION_ACTION)
	elif action_player.has_animation(END_ATTACK_ANIMATION_ACTION):
		action_player.play(END_ATTACK_ANIMATION_ACTION)


func action(_primary: bool):
	pass


func release_charge(_total_charge: float, _primary: bool):
	pass


func on_equip():
	var damage_areas= Utils.find_custom_children(self, DamageArea)
	if damage_areas:
		var damage_area: DamageArea= damage_areas[0] as DamageArea
		
		var entity_parent: Node
		entity_parent= Utils.find_custom_parent(self, BasePlayer)
		if not entity_parent:
			entity_parent= Utils.find_custom_parent(self, BaseMob)
		
		if not entity_parent: return
		
		var hurt_boxes= Utils.find_custom_children(entity_parent, HurtBox)
		if hurt_boxes:
			var hurt_box: HurtBox= hurt_boxes[0] as HurtBox
			damage_area.exclude_hurtbox= hurt_box


func on_unequip():
	pass


func can_mine()-> bool:
	return type.can_mine()


func get_hand()-> Hand:
	return get_parent().get_parent()


func get_player()-> BasePlayer:
	return get_hand().player
