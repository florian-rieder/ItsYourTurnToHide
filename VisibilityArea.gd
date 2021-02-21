extends Area2D


# Default visibility is 1, more make you easier to see less make you more stealthy
# The area is a square, but with the same trick as with doors it could be anything
export(float,0.0,2.0) var visibility = 1 


func _on_VisibilityArea_body_entered(body):
	if body.name == "Player":
		body.visibility_set(visibility)


func _on_VisibilityArea_body_exited(body):
	if body.name == "Player":
		# reset to 1
		body.visibility_set()
