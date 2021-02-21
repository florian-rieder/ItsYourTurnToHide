extends Actor

export(float) var detect_distance = 5

onready var sprite = $Sprite

func _ready():
	_velocity.x = 0
	
# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	if _velocity.x > 0:
		sprite.scale.x = -1
	elif _velocity.x < 0:
		sprite.scale.x = 1
		
	_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y


func run_away(pos: Vector2):
	if pos.distance_to(global_position) < detect_distance:
		_velocity.x = speed.x
	if randi() % 2 == 0:
		_velocity.x *= -1
