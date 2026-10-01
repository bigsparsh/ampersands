@tool
extends BTAction

@export var direction: int = 1

var actor: AgentBase: 
	get: return agent as AgentBase

func _generate_name() -> String:
	return "Face the direction - [%s]" % [
		direction
	]

func _enter() -> void:
	actor.face(direction)
	
