@icon("res://addons/at-icons/node2d/heart_broken.svg")
class_name HurtBox
extends Area2D

@export var health: Health

var last_attack_vector: Vector2


func _ready() -> void:
	assert(health, "Health not set for [%s]'s hurtbox" % owner.name)


func take_damage(amount: float, knockback: Vector2, source: HitBox) -> void:
	last_attack_vector = owner.global_position - source.owner.global_position
	health.take_damage(amount, knockback)
	if owner.has_method(&"apply_knockback"):
		owner.apply_knockback(knockback)
