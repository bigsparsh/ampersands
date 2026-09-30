extends CharacterBody2D

const DEBUG_TICK = preload("uid://byjxn46oactcj")

@export_category("Debug")
#@export var tick_fade_time: float = 5.0
#@export var debug_draw: Script

@export_category("Player Elements")
#@export var sprite: AnimatedSprite2D 
@export var label: Label 

@export_category("Movement")
@export var walk_speed: float = 500
@export var run_speed: float = 600
@export var jump_speed: Vector2 = Vector2(450, -1000)
@export var coyote_time: float = 350
@export var jump_buffer_time: float = 1.0
@export var wall_gravity: float = 350
@export var gravity_multiplier: float = 1.0
@export var dash_speed: float = 1200
@export var dash_time: float = 0.15
var facing: bool = false
var direction: float

@export_category("HSM")
@export var hsm: LimboHSM
@onready var states = hsm.get_children().reduce(
	func(dict: Dictionary, key: LimboState):
		dict[key.name] = key
		return dict
, {})

func _ready() -> void:
	_init_state_machine()

func _init_state_machine () -> void:
	hsm.add_transition(states[&'Idle'], states[&'Walk'], &"to_walk")
	hsm.add_transition(states[&'Idle'], states[&'Jump'], &"to_jump")
	hsm.add_transition(states[&'Idle'], states[&'Dash'], &"to_dash")
	
	hsm.add_transition(states[&'Walk'], states[&'Idle'], &"to_idle")
	hsm.add_transition(states[&'Walk'], states[&'Jump'], &"to_jump")
	hsm.add_transition(states[&'Walk'], states[&'Fall'], &"to_fall")
	hsm.add_transition(states[&'Walk'], states[&'Dash'], &"to_dash")
	
	hsm.add_transition(states[&'Jump'], states[&'Fall'], &"to_fall")
	hsm.add_transition(states[&'Jump'], states[&'Dash'], &"to_dash")
	hsm.add_transition(states[&'Jump'], states[&'Jump'], &"to_jump")
	
	hsm.add_transition(states[&'Fall'], states[&'Idle'], &"to_idle")
	hsm.add_transition(states[&'Fall'], states[&'Jump'], &"to_jump")
	hsm.add_transition(states[&'Fall'], states[&'Dash'], &"to_dash")
	
	hsm.add_transition(states[&'Dash'], states[&'Fall'], &"to_fall")
	
	hsm.initial_state = states['Idle']
	hsm.initialize(self)
	hsm.set_active(true)

var current_paths = []



func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta * gravity_multiplier
		
	direction = Input.get_axis("left", "right")
	if direction:
		#sprite.flip_h = true if direction == -1 else false
		facing = true if direction == -1 else false
	label.text = "State: {0}\nGravityM: {1}\nGravity:{2}"\
	.format([hsm.get_active_state().name, 
			 gravity_multiplier,
			 get_gravity() * delta * gravity_multiplier])
	move_and_slide()
