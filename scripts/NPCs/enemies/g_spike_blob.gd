extends AgentBase


func move(p_velocity: Vector2):
	velocity = velocity.lerp(p_velocity, 0.1)
	
func stop_movement(x: bool = true, y: bool = true):
	move(Vector2.ZERO)