extends RigidBody3D

const JUMP_INTERVAL = 3.0  
const JUMP_FORCE = 4.0  
var jump_timer = 0.0 

var collision_shape # Declare the variable here

@onready var the_node = self   # Get a reference to the node this script is attached to.

func _ready():
	collision_shape = get_node("CollisionShape3D")
	if collision_shape == null:  
		print("Warning: No CollisionShape3D child found!")

func _process(delta):
	jump_timer += delta

	if jump_timer >= JUMP_INTERVAL:
		jump_timer = 0.0
		apply_central_impulse(Vector3.UP * JUMP_FORCE)  
		print(the_node.get_name() + "Jumped!") 

