extends CharacterBody2D

# ====================
# STATE
# ====================
enum State { MOVE, SPRINT, DODGE, EXHAUSTED, LIGHT_ATTACK }
var state : State = State.MOVE

# ====================
# MOVEMENT TUNING
# ====================
@export var walk_speed := 200.0
@export var sprint_speed := 350.0
@export var dodge_speed := 600.0

@export var accel := 2000.0
@export var friction := 1800.0

# ====================
# INPUT
# ====================
var input_dir : Vector2 = Vector2.ZERO
var last_input_dir : Vector2 = Vector2.RIGHT

# ====================
# STAMINA
# ====================
@export var max_stamina := 100.0
@export var sprint_drain := 30.0
@export var regen_rate := 15.0
@export var dodge_cost := 30.0

var stamina := max_stamina

# ====================
# DODGE
# ====================
@export var dodge_duration := 0.2
var dodge_timer := 0.0

func _process(_delta):
	# INPUT = INTENT ONLY
	input_dir = Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
        "move_down"
	)

	if input_dir != Vector2.ZERO:
		last_input_dir = input_dir.normalized()

func _physics_process(delta):
	_update_stamina(delta)

	if state == State.DODGE:
		_process_dodge(delta)
		move_and_slide()
		return

	_handle_state_transitions()
	_apply_movement(delta)

	move_and_slide()

# ====================
# STAMINA
# ====================
func _update_stamina(delta):
	stamina = clamp(stamina, 0.0, max_stamina)

	if state != State.SPRINT and state != State.DODGE:
		stamina += regen_rate * delta

	if stamina == 0.0:
		state = State.EXHAUSTED

# ====================
# STATE TRANSITIONS
# ====================
func _handle_state_transitions():
	if Input.is_action_just_pressed("dodge") and stamina >= dodge_cost:
		_start_dodge()
		return

	if Input.is_action_pressed("sprint") and stamina > 0 and input_dir != Vector2.ZERO:
		state = State.SPRINT
	elif state != State.EXHAUSTED:
		state = State.MOVE
	
	if Input.
		
# ====================
# LIGHT ATTACK
# ====================

# ====================
# MOVEMENT
# ====================
func _apply_movement(delta):
	var max_speed := walk_speed

	if state == State.SPRINT:
		max_speed = sprint_speed
		stamina -= sprint_drain * delta
	elif state == State.EXHAUSTED:
		max_speed = walk_speed * 0.5

	if input_dir != Vector2.ZERO:
		var desired_velocity = input_dir.normalized() * max_speed
		velocity = velocity.move_toward(desired_velocity, accel * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

# ====================
# DODGE
# ====================
func _start_dodge():
	stamina -= dodge_cost
	state = State.DODGE
	dodge_timer = dodge_duration
	velocity = last_input_dir * dodge_speed

func _process_dodge(delta):
	dodge_timer -= delta
	if dodge_timer <= 0.0:
		state = State.MOVE
