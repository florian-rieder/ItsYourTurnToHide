extends RigidBody2D

signal bounce(position)

func destroy():
	queue_free()

func _on_Timer_timeout():
	destroy()

func _on_Rock_body_entered(body):
	emit_signal("bounce",global_position)
	get_tree().call_group("Ennemies","distracted",global_position)
