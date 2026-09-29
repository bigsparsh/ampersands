@tool
extends BTCondition

@export var target_var: StringName = &"target_node"
@export var range: float = 500.0

var actor: AgentBase: 
	get: return agent as AgentBase

func _generate_name() -> String:
	return "Is target within [%s]px of the agent?" % [
		LimboUtility.decorate_var(str(range))
	]

func _tick(delta: float) -> Status:
	var target_node: Node2D = blackboard.get_var(target_var, null)
	if not is_instance_valid(target_node):
		return FAILURE
		
	if target_node.global_position.distance_squared_to(actor.global_position) < range * range:
		return SUCCESS
	return FAILURE
