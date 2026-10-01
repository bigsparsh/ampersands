extends CharacterBody2D

const DEBUG_TICK = preload("uid://byjxn46oactcj")

@export_category("Player Elements")
@export var sprite: Sprite2D
@export var label: Label
@export_category("Movement")
@export var walk_speed: float = 500
@export var run_speed: float = 600
@export var jump_speed: Vector2 = Vector2(450, -1000)
@export var coyote_time: float = 350
@export var jump_buffer_time: float = 0.15
@export var wall_gravity: float = 350
@export var gravity_multiplier: float = 1.0
@export var dash_speed: float = 1200
@export var dash_time: float = 0.15
@export_category("Stats")
@export var kb_modifier: Vector2 = Vector2(1000, 1000)
@export var health: float = 10.0
@export var invincibility_period: float = 2.0
@export_category("HSM")
@export var hsm: LimboHSM

var facing: bool = false
var direction: float

@onready var states = hsm.get_children().reduce(
	func(dict: Dictionary, key: LimboState):
		dict[key.name] = key
		return dict,
	{ },
)


func _ready() -> void:
	_init_state_machine()


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta * gravity_multiplier

	direction = Input.get_axis("left", "right")
	if direction:
		#sprite.flip_h = true if direction == -1 else false
		facing = true if direction == -1 else false
	label.text = "State: {0}\nGravityM: {1}\nGravity:{2}\nHealth: {3}" \
			.format(
				[
					hsm.get_active_state().name,
					gravity_multiplier,
					get_gravity() * delta * gravity_multiplier,
					health,
				],
			)
	move_and_slide()


# Knockback
func apply_knockback(dir: Vector2):
	dir.x *= 1 if facing else -1
	velocity = dir * kb_modifier


# Invincibility
func apply_invincibility():
	health = 999999999.0
	await get_tree().create_timer(invincibility_period).timeout
	health = 10.0


func _init_state_machine() -> void:
	hsm.add_transition(states[&'Idle'], states[&'Walk'], &"to_walk")
	hsm.add_transition(states[&'Idle'], states[&'Jump'], &"to_jump")
	hsm.add_transition(states[&'Idle'], states[&'Dash'], &"to_dash")
	hsm.add_transition(states[&'Idle'], states[&'Hurt'], &"to_hurt")

	hsm.add_transition(states[&'Walk'], states[&'Idle'], &"to_idle")
	hsm.add_transition(states[&'Walk'], states[&'Jump'], &"to_jump")
	hsm.add_transition(states[&'Walk'], states[&'Fall'], &"to_fall")
	hsm.add_transition(states[&'Walk'], states[&'Dash'], &"to_dash")
	hsm.add_transition(states[&'Walk'], states[&'Hurt'], &"to_hurt")

	hsm.add_transition(states[&'Jump'], states[&'Fall'], &"to_fall")
	hsm.add_transition(states[&'Jump'], states[&'Dash'], &"to_dash")
	hsm.add_transition(states[&'Jump'], states[&'Jump'], &"to_jump")
	hsm.add_transition(states[&'Jump'], states[&'Hurt'], &"to_hurt")

	hsm.add_transition(states[&'Fall'], states[&'Idle'], &"to_idle")
	hsm.add_transition(states[&'Fall'], states[&'Jump'], &"to_jump")
	hsm.add_transition(states[&'Fall'], states[&'Dash'], &"to_dash")
	hsm.add_transition(states[&'Fall'], states[&'Hurt'], &"to_hurt")

	hsm.add_transition(states[&'Dash'], states[&'Fall'], &"to_fall")
	hsm.add_transition(states[&'Dash'], states[&'Hurt'], &"to_hurt")

	hsm.add_transition(states[&'Hurt'], states[&'Fall'], &"to_fall")

	hsm.initial_state = states['Idle']
	hsm.initialize(self)
	hsm.set_active(true)
