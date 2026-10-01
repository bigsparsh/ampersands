class_name AgentBase
extends CharacterBody2D


@export var gravity: float = 2000.0
@export var gravity_multiplier: float = 1.0
@export var facing: int = 1
@export_flags_2d_physics var los_collision_mask: int = 3

@onready var sprite: Sprite2D = %Sprite
@onready var visuals: Node2D = %Visuals
@onready var front_wall_sensor: RayCast2D = %FrontWallSensor
@onready var front_floor_sensor: RayCast2D = %FrontFloorSensor
@onready var health: Health = %Health
@onready var los_origin: Marker2D = %LOSOrigin

	
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta * gravity_multiplier
	move_and_slide()
	
func has_line_of_sight_to(target: Node2D, mask: int = -1) -> bool:
	if mask < 0:
		mask = los_collision_mask

	var query_positions: Array[Vector2] = [target.global_position]
	
	if "sights" in target:
		var sights := target.sights as Sights
		query_positions = sights.get_sight_positions()
	
	for pos in query_positions:
		var query := PhysicsRayQueryParameters2D.create(
			los_origin.global_position,
			pos,
			mask
		)
		# Don't let the ray hit the agent itself.
		query.exclude = [get_rid()]

		var result := get_world_2d().direct_space_state.intersect_ray(query)

		if result.is_empty() or result["collider"] == target:
			return true

	return false

func face(direction: int):
	facing = sign(direction)
	visuals.scale.x = facing
	#direction = sprite.flip_h

func move(p_velocity: Vector2):
	velocity = p_velocity
	
func stop_movement(x: bool = true, y: bool = true):
	velocity.x = 0.0 if x else velocity.x
	velocity.y = 0.0 if y else velocity.y
