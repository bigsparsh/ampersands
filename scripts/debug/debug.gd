class_name DebugDraw extends Node2D

const DEBUG_TICK = preload("uid://byjxn46oactcj")

static var instance: DebugDraw

@export var fade_time: float = 5.0
@export var enabled: bool = true

func _enter_tree() -> void:
	instance = self

func _exit_tree() -> void:
	if instance == self:
		instance = null

func add_tick(pos: Vector2, color: Color):
	if not enabled: return
	var tick = DEBUG_TICK.instantiate()
	tick.position = pos
	tick.modulate = color
	get_tree().current_scene.add_child(tick)
	
	_remove_object(tick)

func create_dyanmic_path(points: Array[Vector2], color: Color):
	if not enabled: return
	var path := Path2D.new()
	var line := Line2D.new()
	var curve := Curve2D.new()
	
	curve.bake_interval = 4.0
	
	for point in points:
		curve.add_point(point)
		
	path.curve = curve
	
	line.width = 3.0
	line.default_color = color
	line.joint_mode = Line2D.LINE_JOINT_ROUND
	line.begin_cap_mode = Line2D.LINE_CAP_ROUND
	line.end_cap_mode = Line2D.LINE_CAP_ROUND
	
	line.points = curve.get_baked_points()
	
	path.add_child(line)
	
	get_tree().current_scene.add_child(path)
	_remove_object(path)
	_remove_object(line)

func create_two_point_dyanmic_path(start, end, color: Color):
	if not enabled: return
	var path := Path2D.new()
	var line := Line2D.new()
	var curve := Curve2D.new()
	
	curve.bake_interval = 4.0
	curve.add_point(start)
	curve.add_point(end)
		
	path.curve = curve
	
	line.width = 3.0
	line.default_color = color
	line.joint_mode = Line2D.LINE_JOINT_ROUND
	line.begin_cap_mode = Line2D.LINE_CAP_ROUND
	line.end_cap_mode = Line2D.LINE_CAP_ROUND
	
	line.points = curve.get_baked_points()
	
	path.add_child(line)
	
	get_tree().current_scene.add_child(path)
	_remove_object(path)
	_remove_object(line)

func _remove_object(obj):
	await get_tree().create_timer(fade_time).timeout
	obj.queue_free()
