extends ColorRect

onready var _fade_in_tween = $FadeInTween
onready var _fade_out_tween = $FadeOutTween

func _ready():
	fade_in()


func fade_in(duration = 1) -> void:
		_fade_in_tween.interpolate_property(self, "color:a",
		1, 0, duration,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		_fade_in_tween.start()


func fade_out(duration = 1) -> void:
		_fade_out_tween.interpolate_property(self, "color:a",
		0, 1, duration,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		_fade_out_tween.start()
