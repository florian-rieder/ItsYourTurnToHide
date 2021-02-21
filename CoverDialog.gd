extends Node2D


onready var dialog = $NPCDialog
onready var cover = $Cover

func _ready():
	if dialog:
		dialog.set_collider(true)

func triggerDialog():
	if dialog:
		dialog.set_collider(false)
