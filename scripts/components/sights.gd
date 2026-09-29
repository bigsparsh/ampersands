@icon("res://addons/at-icons/node2d/field_of_view.svg")
class_name Sights
extends Node2D



func get_sight_positions() -> Array[Vector2]:
	var positions: Array[Vector2] = []
	for child in get_children():
		positions.push_back(child.global_position)
	return positions
