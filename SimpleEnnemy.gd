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
export(float) var max_left_distance = 100
export(float) var max_right_distance = 100

onready var platform_detector = $PlatformDetector
onready var floor_detector_left = $FloorDetectorLeft
onready var floor_detector_right = $FloorDetectorRight
onready var sprite = $Sprite
onready var distracted_timer = $DistractedTime
onready var lineOfSight = $LineOfSight

var _old_state
var _initial_pos
var _player = null #null if out of sight
var _player_facing_dir: Vector2

#Initial speed
func _ready():
	_velocity.x = speed.x if state == State.WALKING else 0
	_initial_pos = global_position.x

	
func _physics_process(_delta):
	
	# If the enemy encounters a wall or an edge or at the max distance, the horizontal velocity is flipped.
	if not floor_detector_left.is_colliding():
		_velocity.x = speed.x
	elif not floor_detector_right.is_colliding():
		_velocity.x = -speed.x

	if is_on_wall() or (global_position.x - _initial_pos) < -max_left_distance or (global_position.x - _initial_pos) > max_right_distance:
		_velocity.x *= -1

	# In idle (or random) it stops
	if state == State.IDLE or state == State.DEAD:
		_velocity.x = 0
		
	
		
	# We only update the y value of _velocity as the horizontal movement is handle in Actor.gd (only gravity).
	_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y

	# We flip the Sprite depending on which way the enemy is moving except if it is not moving at all.
	if _velocity.x > 0:
		sprite.scale.x = 1
	elif _velocity.x < 0:
		sprite.scale.x = -1
		
	# Player detection
	if _player:
		lineOfSight.enabled = true
		_player_facing_dir = Vector2(_player.global_position.x - global_position.x, 0)
		lineOfSight.cast_to = _player.global_position - global_position

		if lineOfSight.is_colliding() and lineOfSight.get_collider() == _player:
			if sprite.scale.dot(_player_facing_dir.normalized()) == 1:
				_player.isInSight(global_position.distance_to(_player.global_position))
	

#Get called when a rock hit a surface, pos is the rock position
func distracted(pos: Vector2):
	if global_position.distance_to(pos) < hearing_distance and distracted_timer.is_stopped():
		distracted_timer.start()
		_old_state = state
		state = State.IDLE
		var directionOfNoise = pos - global_position
		sprite.scale.x = 1 if directionOfNoise.x > 0 else -1
		
		
		
func destroy():
	state = State.DEAD
	_velocity = Vector2.ZERO

# Get called at the end of the distracted timeout
func _on_DistractedTime_timeout():
	state = _old_state
	if state == State.WALKING:
		_velocity.x = speed.x if sprite.scale.x > 0 else -speed.x

# The player remember the number of people seeing him, and reacts if his visible or not
func _on_PlayerDetector_body_entered(body):
	if body.name == "Player":
		_player = body

func _on_PlayerDetector_body_exited(body):
	if body.name == "Player":
		_player = null
		
func stun():
	state = State.DEAD
	# A cahnger si on a des anims de stun, sinon juste jouer un son
	queue_free()
