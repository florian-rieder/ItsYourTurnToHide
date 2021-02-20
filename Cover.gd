extends Area2D


export(Texture) var texture
export(String) var msg

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.set_texture(texture)


func _on_Cover_body_entered(body):
	if body.name == "Player":
		body.canInteract(msg,"Cover")
		
func _on_Cover_body_exited(body):
	if body.name == "Player":
		body.resetInteract()
