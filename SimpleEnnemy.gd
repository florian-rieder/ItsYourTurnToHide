class_name Enemy
extends Actor


enum State {
	WALKING,
	IDLE,
	RANDOM,
	DEAD,
}

export(State) var state = State.WALKING
export(float) var hearing_distance = 10.0
export(float) var distracted_time = 2
export(float) var min_detection_time = 0.5

onready var platform_detector = $PlatformDetector
onready var floor_detector_left = $FloorDetectorLeft
onready var floor_detector_right = $FloorDetectorRight
onready var sprite = $Sprite
onready var distracted_timer = $DistractedTime

var _old_state

# This function is called when the scene enters the scene tree.
# We can initialize variables here.
func _ready():
	_velocity.x = speed.x if state == State.WALKING else 0

# Physics process is a built-in loop in Godot.
# If you define _physics_process on a node, Godot will call it every frame.

# At a glance, you can see that the physics process loop:
# 1. Calculates the move velocity.
# 2. Moves the character.
# 3. Updates the sprite direction.
# 4. Updates the animation.

# Splitting the physics process logic into functions not only makes it
# easier to read, it help to change or improve the code later on:
# - If you need to change a calculation, you can use Go To -> Function
#   (Ctrl Alt F) to quickly jump to the corresponding function.
# - If you split the character into a state machine or more advanced pattern,
#   you can easily move individual functions.
func _physics_process(_delta):
	
	# If the enemy encounters a wall or an edge, the horizontal velocity is flipped.
	if not floor_detector_left.is_colliding():
		_velocity.x = speed.x
	elif not floor_detector_right.is_colliding():
		_velocity.x = -speed.x

	if is_on_wall():
		_velocity.x *= -1

	if state == State.IDLE:
		_velocity.x = 0
		
	# We only update the y value of _velocity as we want to handle the horizontal movement ourselves.
	_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y

	# We flip the Sprite depending on which way the enemy is moving.
	sprite.scale.x = 1 if _velocity.x > 0 else -1

func distracted(pos: Vector2):
	if global_position.distance_to(pos) < hearing_distance:
		distracted_timer.start()
		_old_state = state
		state = State.IDLE
		var directionOfNoise = pos - global_position
		sprite.scale.x = 1 if directionOfNoise.x > 0 else -1
		
		
		
func destroy():
	state = State.DEAD
	_velocity = Vector2.ZERO


func _on_DistractedTime_timeout():
	state = _old_state
	if state == State.WALKING:
		_velocity.x = speed.x if sprite.scale.x > 0 else -speed.x


func _on_PlayerDetector_body_entered(body):
	if body.name == "Player":
		body.number_of_people_seeing_you += 1
		


func _on_PlayerDetector_body_exited(body):
	if body.name == "Player":
		body.number_of_people_seeing_you -= 1


func _on_DetectionTimer_timeout():
	print("Detected")
