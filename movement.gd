extends CharacterBody2D

# enum is a datatype used to declare an ordered set 
enum State {WALK, SPRINT, IDLE, DODGE, EXHAUSTED, JUMP}
#initial declaration of state:
var state : State = State.WALK
#above syntax: state : State = State.WALK is to lock state data type to State

#Movement Declaration:

@export var acceleration = 1000
@export var friction = 600

@export var walk_speed = 200
@export var sprint_speed = 350
@export var dodge_speed = 700


# Input Handling
# := is a type reference assignment
# it not only assigns, but locks the datatype from value on right

# input_dir for current intent, last_input_dir for past intent
@export var input_dir = Vector2.ZERO # Vector2 is just (x,y) coordinates
@export var last_input_dir = Vector2.ZERO


#Stamina Declaration

@export var max_stamina = 150
@export var sprint_drain = 15
@export var dodge_cost = 20
@export var regen_rate = 15

var stamina : float = max_stamina

#Dodge Mechanics

@export var dodge_duration := 0.2
var dodge_timer = 0.0

func _process(delta: float) -> void:
	input_dir = Input.get_vector(
		"left",
		"right",
		"up",
		"down"
	)
	if input_dir != Vector2.ZERO:
		#normalized is used to keep whole number direction, so it's 
		#equal in every direction
		last_input_dir = input_dir.normalized()

#Stamina updation		
func _update_stamina(delta):
	stamina = clamp(stamina, 0.0, max_stamina)
	#				value  , min, max
	if state != State.SPRINT and  state != State.SPRINT:
		stamina += regen_rate * delta
	if stamina == 0.0:
		state = State.EXHAUSTED
		

#Dodge Mechanic:
func _process_dodge():
	pass

#Movement:
func _apply_movement():
	pass


#All physics processess:
func _physics_process(delta: float) -> void:
	
	_update_stamina(delta)
	
	if state = State.DODGE:
		_process_dodge()


	
