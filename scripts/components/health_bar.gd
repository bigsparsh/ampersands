extends ProgressBar

@export var health: Health

func _ready() -> void:
	assert(health, "Health not set for [%s]'s health bar" % owner.name)
	update_progress()
	health.damaged.connect(_on_damaged)

func update_progress() -> void:
	value = 100.0 * health.get_current() / health.max_health

func _on_damaged(_amount: float, _knockback: Vector2):
	update_progress()
