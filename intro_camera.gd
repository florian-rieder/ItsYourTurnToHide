extends Camera2D

export(float) var duration = 5.0
export(NodePath) onready var _player = get_node(_player) as KinematicBody2D
onready var _tween = $Tween

func _ready():
	_tween.interpolate_property(self, "position",
		self.global_position, _player.global_position, duration,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	_tween.start()
	

	
