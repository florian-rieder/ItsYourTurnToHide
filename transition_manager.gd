extends Node2D

export(NodePath) onready var _animation_player = get_node(_animation_player) as AnimationPlayer


func _ready():
	_animation_player.play("transition")
	print(_animation_player)


func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().change_scene("res://village_night.tscn")
