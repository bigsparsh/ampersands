@tool
extends BTCondition

var actor: AgentBase: 
	get: return agent as AgentBase

func _generate_name() -> String:
	return "Is there a Wall ahead?"

func _tick(delta: float) -> Status:
	if actor.front_wall_sensor.is_colliding():
		return SUCCESS
	return FAILURE
