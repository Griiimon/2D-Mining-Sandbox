extends Game



func on_player_spawned():
	for item in DataManager.items:
		if item is HandItem and item.type != HandItem.Type.THROWABLE:
			continue
		player.inventory.add_new_item(item, 99)
