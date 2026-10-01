@tool
extends BTCondition

@export var target_pos_var: StringName = &"target_pos"

var actor: FlyingAgentBase:
	get: return agent as FlyingAgentBase

func _generate_name() -> String:
	return "Is the position stored in [%s] reachable?" % [
		target_pos_var
	]

func _tick(_delta: float) -> Status:
	var target_pos: Vector2 = blackboard.get_var(target_pos_var, Vector2.INF)
	if target_pos == Vector2.INF:
		return FAILURE

	if await actor.is_reachable(target_pos):
		return SUCCESS
	return FAILURE
