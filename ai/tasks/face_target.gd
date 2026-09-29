@tool
extends BTAction

@export var target_var: StringName = &"target_node"

var actor: AgentBase: 
	get: return agent as AgentBase

func _generate_name() -> String:
	return "Face the target - [%s]" % [
		target_var,
	]
	

func _tick(delta: float) -> Status:
	var target_node: Node2D = blackboard.get_var(target_var, null)
	if not is_instance_valid(target_node):
		return FAILURE
	var direction: int = 1 if target_node.global_position.x > actor.global_position.x else -1
	actor.face(direction)
	return SUCCESS
