extends Node2D


export(NodePath) onready var _scene_transition = get_node(_scene_transition) as ColorRect


func _on_scroll_tween_completed(object, key):
	_scene_transition.fade_out()


func _on_Player_credits_song_finished():
	get_tree().quit()
