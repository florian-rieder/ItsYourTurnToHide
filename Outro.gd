extends Node2D


export(NodePath) onready var _scene_transition = get_node(_scene_transition) as ColorRect


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_scroll_tween_completed(object, key):
	_scene_transition.fade_out()


