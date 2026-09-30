@icon("res://addons/at-icons/node2d/sword.svg")
class_name HitBox
extends Area2D


@export var damage: float = 1.0

## Push back the victim.
@export var knockback_enabled: bool = false

## Desired pushback speed.
@export var knockback_strength: float = 500.0


func _ready() -> void:
	area_entered.connect(_area_entered)


func _area_entered(hurtbox: HurtBox) -> void:
	if hurtbox.owner == owner: # avoid self collision
		return
	hurtbox.take_damage(damage, get_knockback(), self)


func get_knockback() -> Vector2:
	var knockback: Vector2
	if knockback_enabled:
		knockback = Vector2.RIGHT.rotated(global_rotation) * knockback_strength
	return knockback
