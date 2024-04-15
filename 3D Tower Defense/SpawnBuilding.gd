extends Area3D

# Reference to the AudioStreamPlayer3D
@onready var audio_stream_player = $SpawnBuildingMusic

func _ready():
	# Connect the signals
	#self.connect("body_entered", self, "_on_body_entered")
	#self.connect("body_exited", self, "_on_body_exited")

func _on_body_entered(body):
	# Check if the body is the player
	if body.name == "Player":
		# Start the music
		audio_stream_player.play()

func _on_body_exited(body):
	# Check if the body is the player
	if body.name == "Player":
		# Stop the music
		audio_stream_player.stop()
