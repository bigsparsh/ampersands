@tool
extends BTAction

@export var x: bool = true
@export var y: bool = false

var actor: AgentBase: 
	get: return agent as AgentBase

func _generate_name() -> String:
	if not x and not y:
		return "Invalid: X and Y both should not be false"
	return "Stop agent's %s movement" % [
		("X" if x else "") + ("Y" if y else "")
	]

func _tick(delta: float) -> Status:
	actor.stop_movement(x, y)
	var xok: bool = true
	var yok: bool = true
	if x:
		xok = is_zero_approx(actor.velocity.x)
	if y:
		yok = is_zero_approx(actor.velocity.y)
	if xok and yok:
		return SUCCESS
	return RUNNING
	
