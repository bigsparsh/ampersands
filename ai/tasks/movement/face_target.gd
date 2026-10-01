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
	var target = blackboard.get_var(target_var, null)
	var target_pos: Vector2
	if target is Node2D:
		target_pos = target.global_position
	elif target is Vector2:
		target_pos = target
	var direction: int = 1 if target_pos.x > actor.global_position.x else -1
	actor.face(direction)
	return SUCCESS
