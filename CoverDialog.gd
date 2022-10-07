extends Node2D


export(bool) var move_on_found = true
export(Vector2) var move_offset = Vector2(10, 0)

onready var dialog = $NPCDialog
onready var cover = $Cover


var _has_been_triggered = false

func _ready():
    if dialog:
        dialog.set_collider(true)

func triggerDialog():
    if dialog and not _has_been_triggered:
        dialog.set_collider(false)
        GameEvents.emit_signal("child_found")
        _has_been_triggered = true
        if move_on_found:
            $NPCDialog/NPC.global_position += move_offset
