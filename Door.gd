extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(String) var suffix = "0"
export(String) var other_suffix = "1"
export(String) var msg = ""

onready var otherDoor = get_node("../Door" + other_suffix)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _on_Door_body_entered(body):
	if body.name == "Player":
		body.canInteract(msg,otherDoor.global_position)
		
func _on_Door_body_exited(body):
	if body.name == "Player":
		body.resetInteract()
