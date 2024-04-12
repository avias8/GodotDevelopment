extends CharacterBody3D


const WALK_SPEED = 7.0
const SPRINT_SPEED = 20.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.01
var speed

# Head bob variables
const bobFreq = 2.0
const bobAmp = 0.08
var t_bob = 0.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Handle sprint
	if Input.is_action_pressed("Sprint"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("Left", "Right", "Forwards", "Backwards")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed) # Note that this built-in code is meant to reduce the character's velocity to zero gradually, like with friction. Online threads suggest it may not work, and simply reduce speed instantaneoulsy.
		velocity.z = move_toward(velocity.z, 0, speed)

	# Head bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)

	move_and_slide()




func ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # To remove the cursor
	
# Defining variables for head (canera location) and camera:
@onready var head = $Head
@onready var camera = $Head/Camera

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY) # Rotating around vertical y-axis to turn camera left and right
		camera.rotate_x(-event.relative.y * SENSITIVITY) # Rotating around horizontal x-axis to turn camera up and down
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(60)) # Limiting up/down camera tilt
		
# Head bob function
func _headbob(time) -> Vector3:
	var headbob_position = Vector3.ZERO
	headbob_position.y = sin(time + bobFreq) * bobAmp
	headbob_position.x = cos(time * bobFreq/2) * bobAmp
	return headbob_position
