extends Node2D


onready var dialog = $NPCDialog
onready var cover = $Cover

var _has_been_triggered = false

func _ready():
	if dialog:
		dialog.set_collider(true)

func triggerDialog():
	if dialog and not _has_been_triggered:
		dialog.set_collider(false)
		GameEvents.emit_signal("child_found")
		_has_been_triggered = true
