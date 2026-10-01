extends LimboState

@export var hurt_time = 0.15


func _enter() -> void:
	agent.sprite.modulate = Color.WHITE
	agent.apply_knockback(Vector2(1, -1))

	await get_tree().create_timer(hurt_time).timeout
	agent.velocity.y = 0
	dispatch("to_fall")
