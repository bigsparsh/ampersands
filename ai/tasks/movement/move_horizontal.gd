@tool
extends BTAction

@export var speed: float = 300.0

var actor: AgentBase:
	get: return agent as AgentBase

func _generate_name() -> String:
	return "Move horizontally in facing direction with speed: [%s]" % speed

func _tick(_delta: float) -> Status:
	if actor == null:
		return FAILURE
	var desired_vel := Vector2(speed * actor.facing, 0)
	actor.move(desired_vel)
	return RUNNING

#func _exit() -> void:
	#actor.move(Vector2.ZERO)
