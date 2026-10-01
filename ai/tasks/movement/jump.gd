@tool
extends BTAction

@export var jump_strength: float = 2000.0

var actor: AgentBase: 
	get: return agent as AgentBase

func _generate_name() -> String:
	return "Jump with force: [%s]" % jump_strength

func _tick(delta: float) -> Status:
	actor.move(Vector2(actor.velocity.x, -jump_strength))
	return SUCCESS
	
