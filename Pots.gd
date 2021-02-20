extends RigidBody2D


export(float) var velocity_to_break = 1



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func destroy():
	queue_free()

func _on_Pots_body_entered(body):
	#print(linear_velocity.length())
	print("bla")
	if linear_velocity.length() > velocity_to_break:
		if body.has_method("stun"):
			body.stun()
		destroy()
