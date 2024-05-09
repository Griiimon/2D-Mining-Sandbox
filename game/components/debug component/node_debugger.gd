extends Node

const DEBUG_NODE= "Debug Component"

func write(node: Node, text: String, detail_level: int= 0, type: DebugComponent.Type= DebugComponent.Type.DEFAULT):
	var debug_component: DebugComponent= node.get_node_or_null(DEBUG_NODE)
	assert(debug_component)
	debug_component.debug_message(text, detail_level, type)
