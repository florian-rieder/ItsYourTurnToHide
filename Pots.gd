extends RigidBody2D


export(float) var velocity_to_break = 1

onready var sprite = $Sprite

var _broken = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func destroy():
	sprite.play("break")
	_broken = true



func _on_Pots_body_entered(body):
	print(linear_velocity.length())
	if linear_velocity.length() > velocity_to_break:
		if body.has_method("stun"):
			body.stun()
		destroy()


func _on_Sprite_animation_finished():
	if _broken:
		queue_free()
