extends Camera2D

export(float) var duration = 35

export(NodePath) onready var _player = get_node(_player) as KinematicBody2D
onready var _tween = $Tween

var offsetv = 1800

func _ready():
    _tween.interpolate_property(self, "position",
        self.global_position, 
        Vector2(_player.global_position.x, _player.global_position.y-offsetv), duration,
        Tween.TRANS_QUAD, Tween.EASE_IN)
    _tween.start()
    
