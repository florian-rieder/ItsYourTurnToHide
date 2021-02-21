extends Node2D

export(Resource) var _dialogue = _dialogue as Dialogue

onready var collision = $Area2D/CollisionShape2D

var _has_been_played = false setget set_played

func _ready():
	GameEvents.connect("dialog_finished", self, "_on_dialog_finished")

func _on_Area2D_body_entered(body):
	if body.name == "Player" and not _has_been_played:
		GameEvents.emit_dialog_initiated(_dialogue)

func _on_dialog_finished(dialog) -> void:
	if dialog == _dialogue:
		_has_been_played = true

func set_played(newVal: bool):
	_has_been_played = newVal
	
		
func set_collider(newVal: bool):
	if newVal:
		collision.disabled = true
	else:
		collision.disabled = false
	
