extends HBoxContainer

onready var left = $Controls/Left
onready var right = $Controls/Right


func _process(delta):
    if Input.is_action_pressed("left"):
        left.visible = false
    if Input.is_action_pressed("right"):
        right.visible = false

    if not left.visible and not right.visible:
        queue_free()
