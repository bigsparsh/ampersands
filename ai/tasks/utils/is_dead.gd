@tool
@icon("res://addons/at-icons/node3d/skull.svg")
extends BTCondition

var actor: AgentBase: 
	get: return agent as AgentBase

func _generate_name() -> String:
	return "Is agent dead?"

func _tick(delta: float) -> Status:
	if actor.health.get_current() <= 0:
		return SUCCESS
	return FAILURE
