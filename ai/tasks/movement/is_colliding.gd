@tool
extends BTCondition

## Only collisions with bodies on these physics layers count.
@export_flags_2d_physics var collision_layer_mask: int = 1

var actor: AgentBase:
	get: return agent as AgentBase

func _generate_name() -> String:
	return "Is agent colliding with something?"

func _tick(delta: float) -> Status:
	for i in actor.get_slide_collision_count():
		var collision := actor.get_slide_collision(i)

		# Check the collided body's layer against our mask.
		var body_layer := PhysicsServer2D.body_get_collision_layer(collision.get_collider_rid())
		if body_layer & collision_layer_mask == 0:
			continue

		return SUCCESS
	return FAILURE