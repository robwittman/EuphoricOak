extends CharacterBody2D


const SPEED = 100.0
const ACCELERATION = 600
const FRICTION = 1000
const JUMP_VELOCITY = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var coyote_jump_timer = $CoyoteJumpTimer

func _physics_process(delta):
	apply_gravity(delta)
	handle_jump()
	
	var input_axis = Input.get_axis("ui_left", "ui_right")
	handle_acceleration(input_axis, delta)
	apply_friction(input_axis, delta)
	
	var was_on_floor = is_on_floor()
	move_and_slide()
	var just_left_ledge = was_on_floor and not is_on_floor() and velocity.y >= 0
	if just_left_ledge:
		coyote_jump_timer.start()
	
func apply_gravity(delta: float):
	if not is_on_floor():
		velocity.y += gravity * delta
		
func handle_jump():
	if is_on_floor() or coyote_jump_timer.time_left > 0.0:
		if Input.is_action_just_pressed("ui_accept"):
			velocity.y = JUMP_VELOCITY
	if not is_on_floor():
		if Input.is_action_just_released("ui_accept") and velocity.y < JUMP_VELOCITY / 2:
			velocity.y = JUMP_VELOCITY / 2
			
func apply_friction(input_axis, delta: float):
	if input_axis == 0:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
		
func handle_acceleration(input_axis, delta: float):
		if input_axis:
			velocity.x = move_toward(velocity.x, input_axis * SPEED, ACCELERATION * delta)
