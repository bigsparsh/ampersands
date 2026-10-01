@tool
extends BTAction


var actor: AgentBase: 
	get: return agent as AgentBase

func _generate_name() -> String:
	return "Flip the facing of the agent"

#func _tick(delta: float) -> Status:
func _enter() -> void:
	print("FLIPP", actor.facing)
	actor.face(-actor.facing)
	
