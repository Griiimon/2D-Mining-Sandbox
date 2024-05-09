extends UIListItem
class_name BuildListItem

var buildable: Buildable



func init(_buildable: Buildable, player: BasePlayer):
	buildable= _buildable
	label.text= buildable.get_display_name()
	update(player)



func update(player: BasePlayer):
	available= buildable.can_build(player.inventory)
	super(player)
