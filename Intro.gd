extends Node2D

export(Resource) var _intro_dialogue = _intro_dialogue as Dialogue

# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect("dialog_finished", self, "_on_dialog_finished")

# launch dialog when the camera stops panning
func _on_cutscene_camera_tween_completed(object, key):
	GameEvents.emit_dialog_initiated(_intro_dialogue)

# when the dialog is finished, fade out
func _on_dialog_finished(dialogue : Dialogue):
	if dialogue == _intro_dialogue:
		$CanvasLayer/SceneTransitionRect.fade_out()

# when the fade out is complete, load the next scene
func _on_FadeOutTween_completed(object, key):
	get_tree().change_scene("res://village_day.tscn")
