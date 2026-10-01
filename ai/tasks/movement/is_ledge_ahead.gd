@tool
extends BTCondition

var actor: AgentBase: 
	get: return agent as AgentBase

func _generate_name() -> String:
	return "Is there's a Ledge ahead?"

func _tick(delta: float) -> Status:
	if not actor.front_floor_sensor.is_colliding():
		return SUCCESS
	return FAILURE
