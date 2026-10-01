@tool
extends BTCondition

var actor: AgentBase: 
	get: return agent as AgentBase

func _generate_name() -> String:
	return "Is agent on Floor?"

func _tick(delta: float) -> Status:
	if actor.is_on_floor():
		return SUCCESS
	return FAILURE
