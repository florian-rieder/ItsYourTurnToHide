class_name Player
extends Actor


const FLOOR_DETECT_DISTANCE = 20.0


onready var platform_detector = $PlatformDetector
onready var sprite = $Sprite

func _ready():
	pass

func _physics_process(_delta):
	var direction = get_direction()

	_velocity = calculate_move_velocity(_velocity, direction, speed)

	var snap_vector = Vector2.DOWN * FLOOR_DETECT_DISTANCE if direction.y == 0.0 else Vector2.ZERO
	var is_on_platform = platform_detector.is_colliding()
	_velocity = move_and_slide_with_snap(
		_velocity, snap_vector, FLOOR_NORMAL, not is_on_platform, 4, 0.9, false
	)

	# When the character’s direction changes, we want to to scale the Sprite accordingly to flip it.
	# This will make Robi face left or right depending on the direction you move.
	if direction.x != 0:
		sprite.scale.x = 1 if direction.x > 0 else -1



func get_direction():
	return Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		0
	)


# This function calculates a new velocity whenever you need it.
# It allows you to interrupt jumps.
func calculate_move_velocity(
		linear_velocity,
		direction,
		speed
	):
	var velocity = linear_velocity
	velocity.x = speed.x * direction.x
	if direction.y != 0.0:
		velocity.y = speed.y * direction.y

	return velocity
