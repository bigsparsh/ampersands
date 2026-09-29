@tool
extends BTAction

var actor: AgentBase: 
	get: return agent as AgentBase

func _generate_name() -> String:
	return "Stop agent's X movement"

func _tick(delta: float) -> Status:
	actor.move(Vector2.ZERO)
	if actor.velocity.is_zero_approx():
		return SUCCESS
	return RUNNING
	
