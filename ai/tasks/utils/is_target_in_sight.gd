@tool
extends BTCondition

@export var target_var: StringName = &"target_node"
@export_flags_2d_physics var collision_mask: int = 3

var actor: AgentBase: 
	get: return agent as AgentBase

func _generate_name() -> String:
	return "Has line of sight to [%s]" % [
		target_var
	]

func _tick(_delta: float) -> Status:
	var target_node: Node2D = blackboard.get_var(target_var, null)

	if not is_instance_valid(target_node):
		return FAILURE

	return SUCCESS if actor.has_line_of_sight_to(target_node, collision_mask) else FAILURE
