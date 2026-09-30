@icon("res://addons/at-icons/node/heart.svg")
class_name Health
extends Node
## Tracks health and emits signal when damaged or dead.

signal death
signal damaged(amount: float, knockback: Vector2)

@export var max_health: float = 10.0

var _current: float


func _ready() -> void:
	_current = max_health


func take_damage(amount: float, knockback: Vector2) -> void:
	if _current <= 0.0:
		return

	_current -= amount
	_current = max(_current, 0.0)

	if _current <= 0.0:
		death.emit()
	damaged.emit(amount, knockback)


## Returns current health.
func get_current() -> float:
	return _current
