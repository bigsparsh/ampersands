@tool
extends BTAction

@export var group: StringName = &"player"
@export var out_var: StringName = &"target_node"

var actor: AgentBase: 
	get: return agent as AgentBase

func _generate_name() -> String:
	return "Find node with group [%s] and set to [%s]" % [
		group,
		out_var
	]

var node: Node2D

func _enter() -> void:
	node = actor.get_tree().get_first_node_in_group(group) as Node2D
	blackboard.set_var(out_var, node)
	
func _tick(delta: float) -> Status:
	if is_instance_valid(node): 
		return SUCCESS
	return FAILURE
