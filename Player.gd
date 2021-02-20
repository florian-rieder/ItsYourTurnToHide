class_name Player
extends Actor

signal canInteract(message)
signal resetInteract

const FLOOR_DETECT_DISTANCE = 20.0

var visibility = 1.0 setget visibility_set

onready var platform_detector = $PlatformDetector
onready var sprite = $Sprite
onready var gun = $Sprite/RockOrigin

var _canInteract = false
var _currentInteractor = null
var _canMove = true

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

func _process(delta):
	if Input.is_action_just_pressed("ui_select") and _canMove:
		var cursorPos = get_global_mouse_position()
		var projectile_direction = -(position - cursorPos).normalized()
		# Flip if shooting behind
		if projectile_direction.x * sprite.scale.x < 0:
			sprite.scale.x *= -1
		gun.shoot(projectile_direction)
	if Input.is_action_just_pressed("interact") and _canInteract:
		match _currentInteractor:
			"Cover":
				if _canMove:
					visibility_set(0)
					_canMove = false
				else:
					visibility_set(1)
					_canMove = true
			var TPposition:
				position = TPposition
				



func get_direction():
	if _canMove:
		return Vector2(
			Input.get_action_strength("right") - Input.get_action_strength("left"),
			0
		)
	else:
		return Vector2(0,0)


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

func visibility_set(newVisibility):
	newVisibility = clamp(newVisibility,0.0,1.0)
	visibility = newVisibility
	sprite.modulate.a = visibility


func canInteract(message, interactor):
	_canInteract = true
	_currentInteractor = interactor
	emit_signal("canInteract",message)


func resetInteract():
	_canInteract = false
	_currentInteractor = ""
	emit_signal("resetInteract")
