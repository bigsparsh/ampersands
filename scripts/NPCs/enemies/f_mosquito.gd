extends FlyingAgentBase


@export var air_friction: float = 0.1


func _physics_process(delta: float) -> void:
	move_and_slide()
	
	
func move(p_velocity: Vector2):
	velocity = velocity.lerp(p_velocity, air_friction)
	
func stop_movement(x: bool = true, y: bool = true):
	stop_nav_agent()
	move(Vector2.ZERO)
