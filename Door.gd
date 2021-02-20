extends Area2D


# Those are a bit useless
export(String) var suffix = "0"
export(String) var other_suffix = "1"
export(String) var msg = ""
# Dunno why on some scenes there is an offset in the tp
export(Vector2) var offset = Vector2(0,0)

onready var otherDoor = get_node("../Door" + other_suffix)

func _on_Door_body_entered(body):
	if body.name == "Player":
		print(otherDoor.global_position)
		body.canInteract(msg,otherDoor.global_position + offset)
		
func _on_Door_body_exited(body):
	if body.name == "Player":
		body.resetInteract()
