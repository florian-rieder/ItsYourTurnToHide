extends Node2D

export(Resource) var _dialogue = _dialogue as Dialogue

var _has_been_played = false

func _ready():
	GameEvents.connect("dialog_finished", self, "_on_dialog_finished")

func _on_Area2D_body_entered(body):
	if body.name == "Player" and not _has_been_played:
		GameEvents.emit_dialog_initiated(_dialogue)

func _on_dialog_finished(dialog) -> void:
	if dialog == _dialogue:
		_has_been_played = true
