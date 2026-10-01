@tool
extends BTAction

@export var min_radius: float = 300.0
@export var max_radius: float = 700.0
@export var originate_from_spawn: bool = true
@export var out_var: StringName = &"target_pos"

var actor: AgentBase: 
	get: return agent as AgentBase

func _generate_name() -> String:
	if originate_from_spawn:
		return "Set [%s] variable to random position from spawn to radii [%s] and [%s]" % [
			out_var, min_radius, max_radius
		]
	return "Set [%s] variable to random position from current position to radii [%s] and [%s]" % [
		out_var, min_radius, max_radius
	]

var spawn_pos: Vector2
var current_pos: Vector2

func _setup() -> void:
	spawn_pos = actor.global_position
	current_pos = spawn_pos

func _enter() -> void:
	current_pos = actor.global_position
	
func _tick(delta: float) -> Status:
	var angle := randf_range(0.0, TAU)
	var mag := randf_range(min_radius, max_radius)
	var offset := Vector2.from_angle(angle) * mag
	var final := offset + (spawn_pos if originate_from_spawn else current_pos)
	blackboard.set_var(out_var, final)
	return SUCCESS
