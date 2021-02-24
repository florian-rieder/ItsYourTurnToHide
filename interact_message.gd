extends Control


export(NodePath) onready var _player = get_node(_player) as KinematicBody2D


func _ready():
	_player.connect("canInteract", self, "_on_canInteract")
	_player.connect("resetInteract", self, "_on_resetInteract")


func _on_canInteract(message : String) -> void:
	$Label.text = message
	self.visible = true


func _on_resetInteract() -> void:
	self.visible = false
