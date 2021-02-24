extends Node2D

class_name Radio

export(String) var message = ""

onready var sound = $AudioStreamPlayer2D

var _on = true

func _process(delta):
	if _on:
		get_tree().call_group("Ennemies","distracted",global_position)

func activate():
	if _on:
		sound.stop()
		$Radio.frame = 0
		$Radio.playing = false
		_on = false
	else:
		sound.play()
		$Radio.playing = true
		_on = true


func _on_Radio_body_entered(body):
	if body.name == "Player":
		body.canInteract(message,"Radio",self)
	if body is RigidBody2D:
		activate()


func _on_Radio_body_exited(body):
	if body.name == "Player":
		body.resetInteract()
