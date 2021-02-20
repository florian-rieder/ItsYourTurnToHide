extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal bounce(position)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func destroy():
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	destroy()


func _on_Rock_body_entered(body):
	emit_signal("bounce",global_position)
	get_tree().call_group("Ennemies","distracted",global_position)
