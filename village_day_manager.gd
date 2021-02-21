extends Node2D

export(Resource) var _ending_dialogue = _ending_dialogue as Dialogue
export(NodePath) onready var _scene_transition = get_node(_scene_transition) as ColorRect

func _ready():
	GameEvents.connect("dialog_finished", self, "_on_dialog_finished")
	
func _on_dialog_finished(dialogue : Dialogue):
	if dialogue == _ending_dialogue:
		_scene_transition.fade_out()


func _on_FadeOutTween_completed(object, key):
	get_tree().change_scene("res://transition.tscn")
