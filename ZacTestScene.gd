extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var TextBox = $UITest
onready var Player = $Player


# Called when the node enters the scene tree for the first time.
func _ready():
	Player.connect("canInteract",self,"update_text")
	Player.connect("resetInteract",self,"update_text")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func update_text(newText = ""):
	TextBox.text = newText
