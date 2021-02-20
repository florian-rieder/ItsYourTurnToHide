extends Node2D

export(Resource) var _dialogue = _dialogue as Dialogue

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		GameEvents.emit_dialog_initiated(_dialogue)
