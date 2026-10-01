extends Path2D

@onready var line: Line2D = $Line2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_line()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func update_line() -> void:
	if curve:
		# get_baked_points() returns a PackedVector2Array representing the curve
		line.points = curve.get_baked_points()
